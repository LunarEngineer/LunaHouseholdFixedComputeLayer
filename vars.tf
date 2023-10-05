variable "proxmox_node_config" {
  description = "A map of Proxmox node configurations for a k8s node."
  type        = object({
    role                 = string
    target_node          = string
    description          = string
    vm_template          = string
    vm_group             = string
    memory               = number
    memory_min           = number
    sockets              = number
    cores                = number
    resource_pool        = string
    network_name         = string
    storage_pool         = string
    k3s_version          = string
    ip_addr              = string
    ip_gw                = string
    ssh_username         = string
    ssh_public_key       = string
    ssh_private_key      = string
  })
}
