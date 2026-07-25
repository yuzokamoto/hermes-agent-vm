variable "hcloud_token" {
  description = "Hetzner Cloud API token. Prefer the HCLOUD_TOKEN environment variable."
  type        = string
  sensitive   = true
  default     = null
}

variable "server_name" {
  description = "VM name."
  type        = string
  default     = "hermes-agent"
}

variable "server_type" {
  description = "Hetzner Cloud server type."
  type        = string
  default     = "cx22"
}

variable "location" {
  description = "Hetzner Cloud location."
  type        = string
  default     = "fsn1"
}

variable "image" {
  description = "Ubuntu image used by the VM."
  type        = string
  default     = "ubuntu-24.04"
}

variable "ssh_public_key" {
  description = "OpenSSH public key authorized for the operator user."
  type        = string
}

variable "admin_cidr" {
  description = "CIDR allowed to access SSH. Use your fixed public IP with /32."
  type        = string
}
