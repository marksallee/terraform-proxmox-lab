output "hostname" {
  description = "Container hostname"
  value       = var.hostname
}

output "vm_id" {
  description = "Proxmox VM/CT ID"
  value       = proxmox_virtual_environment_container.this.vm_id
}

output "ip_address" {
  description = "Container IPv4 address (without CIDR suffix)"
  value       = split("/", var.container_ip)[0]
}
