variable "proxmox_node_config" {
  description = "A map of Proxmox node configurations for a k8s node."
  type        = map(object({
    role          = string
    name          = string
    target_node   = string
    description   = string
    vm_template   = string
    vm_group      = string
    memory        = number
    memory_min    = number
    sockets       = number
    cores         = number
    resource_pool = string
    network_name  = string
    storage_pool  = string
  }))
}
