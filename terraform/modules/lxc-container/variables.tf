variable "node_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "hostname" {
  type = string
}

variable "container_ip" {
  type = string
}

variable "gateway" {
  type = string
}

variable "storage_pool" {
  type = string
}

variable "container_template" {
  type = string
}

variable "cores" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 1024
}

variable "disk_size" {
  type    = number
  default = 8
}

variable "ssh_public_key" {
  description = "SSH public key installed for the container's root user via cloud-init-style provisioning"
  type        = string
  default     = null
}