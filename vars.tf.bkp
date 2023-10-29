variable "k8s_nodes" {
  description = "Simple definition of network"
  type        = map(list(string))
  default = {
    "k8s_nodes_master": [],
    "k8s_nodes_control": [],
    "k8s_nodes_worker": [],
  }
}

variable "ssh_username" {
  description = "Username to connect"
}

variable "ssh_public_key" {
  description = "Public key to connect"
}

variable "ssh_private_key" {
  description = "Private key to connect"
}

variable "control_plane_node_args" {
  description = "This is the default configuration mapping for a k8s control node"
  type = object({
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
  })
  default = {
    description          = "This is a k8s control node for the Gaia Cluster"
    vm_template          = "ubuntu-2004-cloudinit-template"
    vm_group             = "fixed-compute-layer"
    memory               = 8192
    memory_min           = 4096
    sockets              = 2
    cores                = 1
    resource_pool        = "fixed-compute-layer"
    network_name         = "vmbr0"
    storage_pool         = "fixed-compute-nfs-server"
  }
}

variable "worker_plane_node_args" {
  description = "This is the default configuration mapping for a k8s worker node"
  type = object({
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
  })
  default = {
    description          = "This is a k8s worker node for the Gaia Cluster"
    vm_template          = "ubuntu-2004-cloudinit-template"
    vm_group             = "fixed-compute-layer"
    memory               = 8192
    memory_min           = 4096
    sockets              = 2
    cores                = 1
    resource_pool        = "fixed-compute-layer"
    network_name         = "vmbr0"
    storage_pool         = "fixed-compute-nfs-server"
  }
}
