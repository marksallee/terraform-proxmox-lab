# Roadmap

Rough priority order. Each item is scoped to be doable incrementally without
breaking the working state of the lab.

## Near term

- [x] Fix the Terraform/Ansible bootstrap chain end-to-end (SSH key injected
      at container creation, first Ansible connection as root, automation
      user created from there).
- [x] Terraform outputs for container hostname/vm_id/IP.
- [ ] GitHub Actions CI: `terraform fmt -check`, `terraform validate`,
      `ansible-playbook --syntax-check`, and `ansible-lint` on every push/PR.
- [ ] Add a deployed-lab screenshot and a redacted example `terraform plan`
      to the README.

## Medium term

- [ ] Deploy multiple containers from a `for_each` over a map variable
      instead of one hand-written module block per host, so scaling the lab
      out is a data change, not a code change.
- [ ] Basic observability: a `node_exporter` Ansible role on every host plus
      a Prometheus + Grafana container, so the lab can show dashboards, not
      just "it's running."
- [ ] Ansible Vault (or SOPS) for the API token and SSH key material instead
      of relying solely on gitignored local files.

## Longer term / stretch

- [ ] A minimal Kubernetes cluster (k3s) alongside the LXC containers, to
      demonstrate container orchestration on the same Proxmox host —
      directly relevant to hybrid on-prem/cloud platform work.
- [ ] Terraform remote state (e.g., an S3-compatible backend) instead of
      local state, to demonstrate the same workflow teams use once more than
      one person/machine runs `apply`.
- [ ] A second Proxmox node to exercise placement/anti-affinity instead of a
      single-node lab.

See [design-decisions.md](design-decisions.md) for the reasoning behind
what's already built and why some of the above is deliberately not done yet.
