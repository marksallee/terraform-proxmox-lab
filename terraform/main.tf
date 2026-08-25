module "web01" {
  source = "./modules/lxc-container"

  node_name          = var.proxmox_node
  vm_id              = 101
  hostname           = "web01"
  storage_pool       = var.storage_pool
  container_template = var.container_template
  container_ip       = "10.42.0.101/24"
  gateway            = var.gateway
  # ssh_public_key = file("~/.ssh/id_ed25519.pub")

  cores     = 1
  memory    = 1024
  disk_size = 8
}

module "web02" {
  source = "./modules/lxc-container"

  node_name          = var.proxmox_node
  vm_id              = 102
  hostname           = "web02"
  storage_pool       = var.storage_pool
  container_template = var.container_template
  container_ip       = "10.42.0.102/24"
  gateway            = var.gateway
  # ssh_public_key = file("~/.ssh/id_ed25519.pub")

  cores     = 1
  memory    = 1024
  disk_size = 8
}

module "postgres01" {
  source = "./modules/lxc-container"

  node_name          = var.proxmox_node
  hostname           = "postgres01"
  vm_id              = 110
  container_ip       = "10.42.0.110/24"
  storage_pool       = var.storage_pool
  container_template = var.container_template
  gateway            = var.gateway
  # ssh_public_key = file("~/.ssh/id_ed25519.pub")

  memory    = 4096
  cores     = 2
  disk_size = 20
}
