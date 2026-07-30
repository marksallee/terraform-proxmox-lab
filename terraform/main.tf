module "web01" {
  source = "./modules/lxc-container"

  node_name          = var.proxmox_node
  vm_id              = 101
  hostname           = "web01"
  storage_pool       = var.storage_pool
  container_template = var.container_template
  container_ip       = "192.168.4.101/22"
  gateway            = var.gateway

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
  container_ip       = "192.168.4.102/22"
  gateway            = var.gateway

  cores     = 1
  memory    = 1024
  disk_size = 8
}

module "postgres01" {
  source    = "./modules/lxc-container"
  node_name = var.proxmox_node
  hostname  = "postgres01"
  vm_id     = 110
  container_ip = "192.168.4.110/22"
  storage_pool  = var.storage_pool
  container_template = var.container_template
  gateway            = var.gateway

  memory = 4096
  cores = 2
  disk_size = 20
}