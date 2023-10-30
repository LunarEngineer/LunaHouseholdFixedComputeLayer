# Proxmox credentials
variable "pm_api_user" {
  description = "Proxmox user"
  sensitive   = false
}

variable "pm_api_port" {
  description = "The port for the Proxmox server"
  sensitive   = false
}

variable "pm_api_ip" {
  description = "The ip for the Proxmox server"
  sensitive   = false
}

variable "pm_api_token_id" {
  description = "The token ID for the Proxmox server"
  sensitive   = false
}

variable "pm_api_token_secret" {
  description = "The token secret for the Proxmox server"
  sensitive   = true
}