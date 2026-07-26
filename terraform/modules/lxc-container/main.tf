resource "proxmox_virtual_environment_container" "this" {

  tags = [
    "terraform",
    "lab",
    "github"
  ]

  node_name = var.node_name
  vm_id     = var.vm_id

  unprivileged = true

  features {
    nesting = true
  }

  initialization {
    hostname = var.hostname

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
    size         = var.disk_size
  }

  operating_system {
    template_file_id = var.container_template
    type             = "ubuntu"
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }
}