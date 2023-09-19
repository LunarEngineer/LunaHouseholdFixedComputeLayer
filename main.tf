#########################
# Primary Compute Layer #
#########################
# This deploys a k8s nodes.
# This uses the parameter `ci_custom` to pass a custom cloud init configuration file.

resource "telmate_proxmox_vm_qemu" "k8s_node" {
  name             = "k8s-node-${var.proxmox_node_config.role}-${var.proxmox_node_config.name}"
  target_node      = var.proxmox_node_config.target_node # Specify the Proxmox cluster node
  vmid             = 0  # VM ID are assigned automatically.
  desc             = var.proxmox_node_config.description
#   define_connection_info
#   bios             = "seabios"
  onboot           = true  # Turn on when the node is on.
  oncreate         = true  # Turn on when deployed.
  tablet           = false  # Turn on tablet device (needed for mouse)
  agent            = 1  # Turn on the qemu agent (TODO: do not forget to enable the daemon)
  iso              = "Name of iso"  # iso image to use (when clone not set)
  clone            = var.proxmox_node_config.vm_template  # VM Template to use
  full_clone       = true  # Turn off for linked clones (TODO: Research viability)
  hastate          = "started"  # On and ready to go.
  hagroup          = var.proxmox_node_config.vm_group  # VM group label to use
  memory           = var.proxmox_node_config.memory  # Memory in Megabytes
  balloon          = var.proxmox_node_config.memory_min  # Minimum memory in Megabytes, used for auto allocation
  sockets          = var.proxmox_node_config.sockets  # The number of sockets
  cores            = var.proxmox_node_config.cores  # Cores per socket
  cpu              = "host"  # CPU to emulate: See https://pve.proxmox.com/pve-docs/chapter-qm.html#qm_cpu
  pool             = var.proxmox_node_config.resource_pool  # proxmox resource pool to add node to
  os_type          = "ubuntu"  # centos, cloud-init
#   os_network_config= ""  # TODO: Research 
  cicustom         = "path to template file"
  #########################
  # Network Configuration #
  #########################
  network {
    model            = "virtio"
    bridge           = var.proxmox_node_config.network_name
  }
  #
  # Disks
  disk {
    type             = "virtio"
    storage          = var.proxmox_node_config.storage_pool
    size             = "10G"
  }
}