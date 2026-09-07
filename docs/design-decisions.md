# Design Decisions

Notes on the choices made in this lab and why, kept here so the reasoning
survives even after the code around it changes.

## Unprivileged LXC containers

Containers are created with `unprivileged = true`. Unprivileged containers map
root inside the container to an unprivileged UID on the Proxmox host, so a
container-escape does not hand an attacker root on the hypervisor. This is the
same trade-off a platform team makes when choosing rootless containers or
gVisor/Kata in production: slightly less compatibility (some workloads that
need real kernel capabilities won't run) in exchange for a much smaller blast
radius if a single workload is compromised.

## LVM-Thin storage instead of a directory-backed datastore

The lab's storage pool is LVM-Thin rather than the default `local` directory
storage. Thin provisioning means container disks are only allocated space as
they actually write data, and LVM snapshots are near-instant, which matters
once you start iterating on `terraform apply`/`destroy` cycles repeatedly on
a laptop-class disk.

## Static addressing instead of DHCP

Containers are given static `ip_config` blocks instead of relying on DHCP.
This was originally a workaround: LXC containers on this Proxmox host were
not reliably picking up DHCP leases, so tracking that down was itself part of
the lab. Static addressing also happens to be the right call for anything
Terraform is going to hand to Ansible immediately afterward — Ansible's
inventory needs a stable address, and "IP address is an input to `terraform
apply`, not an output you have to go discover" keeps the provisioning story
reproducible.

## A reusable `lxc-container` module instead of three copy-pasted resources

`terraform/modules/lxc-container` takes hostname, IP, resources, and an SSH
key as inputs and returns hostname/vm_id/ip as outputs. `main.tf` then
instantiates it three times (`web01`, `web02`, `postgres01`). The point isn't
that three resources would have been unmanageable — it's demonstrating the
module boundary a real environment needs once there are 30 containers instead
of 3: one place to change "how a container is built," N call sites that only
specify "how this container differs."

## Two SSH keys, not one

Terraform injects one SSH key into each container's `root` account at
creation time (`ssh_public_key` -> `initialization.user_account.keys`). That
key exists for exactly one purpose: to let Ansible's `bootstrap` role make
first contact. The `bootstrap` role then creates a dedicated `ansible`
service account with its own separate key and passwordless sudo, and every
Ansible play after `bootstrap` connects as that account instead.

This mirrors how real infrastructure separates a break-glass/initial-access
credential from the identity automation actually runs as day to day: the
root key is never used again after bootstrap, so if the automation user's key
is ever rotated or revoked, it doesn't touch how new nodes get their first
connection.

## Role layout: bootstrap / common / web / postgres

Roles are split by responsibility rather than by host: `bootstrap` (create
the automation user) and `common` (baseline packages, updates) apply to every
host; `web` and `postgres` apply only to the hosts that need them. This is
the standard Ansible pattern for the same reason Kubernetes separates
DaemonSets from Deployments — "runs everywhere" and "runs on specific roles"
are different concerns and shouldn't be tangled into one task list per host.

## Operational gotchas hit while building this

Real infrastructure work is mostly debugging things that look like they
should just work. A few of the sharper edges hit while getting the
Terraform → Ansible pipeline running end to end, kept here because they're
the kind of thing worth being able to speak to in an interview:

- **Ansible inventory group vars beat a play's `remote_user:` keyword.**
  `inventory.ini` sets `ansible_user=ansible` in `[all:vars]` so that every
  later play connects as the dedicated automation user. But the very first
  play — the one that has to connect as `root` because the `ansible` user
  doesn't exist yet — declared `remote_user: root`, and that was silently
  losing to the inventory variable every time. Ansible's variable precedence
  puts inventory group vars *above* a play's `remote_user` keyword, so every
  connection was quietly trying `ansible@`, failing, and giving errors that
  looked like a broken SSH key rather than a precedence bug. The fix is to
  override with a play **variable** (`vars: { ansible_user: root }`) instead
  of the keyword — play vars sit higher in the precedence order than
  inventory group vars, so that's what actually wins.

- **Terraform state can say something is applied when the live host disagrees.**
  Proxmox only writes a container's `initialization.user_account` (the SSH
  key baked in at boot) once, at creation time — it isn't something that
  gets reapplied to an already-running container. Because the intended key
  value hadn't changed since a much earlier `apply` (from before a botched
  merge left the setting broken), Terraform correctly reported "0 changes"
  even though the *running* containers had never actually received a working
  key. State matching config is not the same guarantee as the real world
  matching config. The fix was `terraform apply -replace=<resource>` to force
  real recreation instead of trusting an in-place "no diff" result.

- **LXC containers share the Proxmox host's kernel clock.** Unlike a full VM,
  an LXC container has no clock of its own. When this lab's Proxmox host
  (itself a nested VM under VirtualBox) sat powered off for a while and came
  back with a stale system clock, every container simultaneously failed
  `apt update` with "Release file is not valid yet" — a clock-skew symptom
  that's easy to misread as a networking or mirror problem. Fixing the
  host's clock fixed all three containers at once; no per-container fix was
  needed or would have made sense.

- **Ephemeral containers break SSH host-key pinning by design.** Every time
  a container is destroyed and recreated at the same IP (which this lab does
  routinely via `terraform apply -replace`), it gets a brand-new SSH host
  key. SSH's `known_hosts` pinning exists specifically to reject that
  situation as a possible man-in-the-middle attack. That protection is the
  right default for anything real, but it's pure friction for a disposable
  lab, so `ansible.cfg` explicitly disables host-key persistence for these
  hosts (`UserKnownHostsFile=/dev/null`) rather than requiring a manual
  `ssh-keygen -R <ip>` after every rebuild.

## What's intentionally out of scope (for now)

This is a single-node home lab, so a few things a production platform would
need are deliberately not here yet, and are tracked in
[roadmap.md](roadmap.md) instead of half-implemented:

- No HA/clustering — there's one Proxmox node.
- No secrets manager — the API token and SSH keys live in a local,
  gitignored `terraform.tfvars` and the operator's `~/.ssh`, which is fine
  for a lab but is explicitly called out as the first thing to replace
  (Vault, SOPS, or cloud KMS-backed secrets) before this pattern would be
  production-appropriate.
- No TLS termination or external DNS — nginx serves plain HTTP on the lab
  network only.
