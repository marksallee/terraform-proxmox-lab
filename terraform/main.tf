resource "proxmox_virtual_environment_container" "ubuntu" {

  tags = [
    "terraform",
    "lab",
    "github"
  ]

  node_name = var.proxmox_node
  vm_id     = var.container_id

  unprivileged = true

  features {
    nesting = true
  }

  initialization {
    hostname = var.container_name

    ip_config {
      ipv4 {
        address = var.container_ip
        gateway = var.gateway
      }
    }
  }

  network_interface {
    name     = "veth0"
    firewall = false
  }

  disk {
    datastore_id = var.storage_pool
    size         = 8
  }

  operating_system {
    template_file_id = var.container_template
    type             = "ubuntu"
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }
}