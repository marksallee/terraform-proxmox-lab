                    Windows Desktop
                    VirtualBox
                         │
                    Proxmox VE
                         │
      ┌──────────────────┼──────────────────┐
      │                  │                  │
   web01             web02           postgres01
   Ubuntu            Ubuntu            Ubuntu
    nginx             nginx          PostgreSQL

===============================================

GitHub
   │
terraform apply
   │
   ├── web01 (Ubuntu)
   ├── web02 (Ubuntu)
   └── postgres01 (Ubuntu)
          │
          ▼
ansible-playbook site.yml
          │
          ├── Create admin user
          ├── Install your SSH public key
          ├── apt update
          ├── Install nginx on web servers
          ├── Install PostgreSQL on database server
          ├── Enable services
          └── Verify everything is running