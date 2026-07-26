## Terraform Proxmox Lab

Infrastructure-as-Code home lab demonstrating:

• Terraform
• Proxmox VE 9
• Ubuntu LXC containers
• Git version control

Current Features

✓ Deploy Ubuntu LXC containers
✓ Dedicated LVM-Thin storage
✓ API token authentication
✓ Variable-driven configuration

Roadmap

□ Multiple containers
□ Terraform modules
□ Ansible provisioning
□ GitHub Actions CI
□ Docker deployment
□ Monitoring stack

Troubleshooting

- Built Proxmox 9 inside VirtualBox.
- Investigated LXC DHCP failures using tcpdump, dhclient, and bridge inspection.
- Switched to static IP addressing for the lab.