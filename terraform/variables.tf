variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS certificate verification"
  type        = bool
  default     = true
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "proxmox"
}

variable "storage_pool" {
  description = "LVM-Thin storage pool"
  type        = string
  default     = "lab-storage"
}

variable "container_template" {
  description = "Ubuntu LXC template"
  type        = string
  default     = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

variable "container_id" {
  type    = number
  default = 101
}

variable "container_name" {
  type    = string
  default = "web01"
}

variable "container_ip" {
  description = "Container IPv4 address with CIDR"
  type        = string
  default     = "192.168.4.101/22"
}

variable "gateway" {
  description = "Default gateway"
  type        = string
  default     = "192.168.4.1"
}