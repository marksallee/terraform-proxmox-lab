# Terraform Proxmox Lab

A home lab project demonstrating Infrastructure as Code (IaC) using Terraform and Proxmox VE.

This repository documents the process of building, provisioning, and managing Linux containers and virtual machines using Terraform against a Proxmox cluster.

## Project Goals

- Learn Terraform through practical infrastructure automation.
- Build a reusable Proxmox home lab.
- Demonstrate Infrastructure as Code best practices.
- Develop a portfolio project for Platform Engineer and DevOps roles.
- Expand the project with Ansible and CI/CD automation.

## Planned Architecture

```
Windows Laptop
      │
      ▼
Terraform (WSL)
      │
      ▼
Proxmox VE
      │
 ┌──────────────┐
 │ lab-storage  │
 └──────────────┘
      │
 ├── web01 (Ubuntu LXC)
 └── web02 (Ubuntu LXC)
```

## Current Status

- [x] Proxmox installed
- [x] Dedicated LVM-Thin storage
- [x] Terraform project created
- [ ] Configure Terraform provider
- [ ] Deploy first container
- [ ] Parameterize infrastructure
- [ ] Add Ansible provisioning
- [ ] Add GitHub Actions

## Technologies

- Terraform
- Proxmox VE
- Linux
- LXC
- Git
- GitHub

## Roadmap

### Phase 1

- Proxmox installation
- Storage configuration

### Phase 2

- Terraform connectivity
- First LXC deployment

### Phase 3

- Multiple containers
- Variables
- Outputs

### Phase 4

- Ansible provisioning
- NGINX installation

### Phase 5

- GitHub Actions
- Documentation
- Architecture diagrams
