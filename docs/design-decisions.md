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
