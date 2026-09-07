output "containers" {
  description = "Hostname, VM ID, and IP address for every provisioned container"
  value = {
    web01      = { vm_id = module.web01.vm_id, ip_address = module.web01.ip_address }
    web02      = { vm_id = module.web02.vm_id, ip_address = module.web02.ip_address }
    postgres01 = { vm_id = module.postgres01.vm_id, ip_address = module.postgres01.ip_address }
  }
}
