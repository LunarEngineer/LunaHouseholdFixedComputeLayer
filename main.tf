#######################
# Fixed Compute Layer #
#######################
# This deploys a k8s node.

resource "proxmox_vm_qemu" "k8s_node" {
  name             = "k8s-node-${var.proxmox_node_config.role}-${var.proxmox_node_config.target_node}"
  target_node      = var.proxmox_node_config.target_node # Specify the Proxmox cluster node
  vmid             = 0  # VM ID are assigned automatically.
  desc             = var.proxmox_node_config.description  # General description of the node.
  provider         = proxmox  # Pass in the provider information
  onboot           = true  # Turn on when the node is on.
  oncreate         = true  # Turn on when deployed.
  tablet           = false  # Turn on tablet device (needed for mouse)
  # agent            = 1  # Turn on the qemu agent (TODO: do not forget to enable the daemon)
  hastate          = "started"  # On and ready to go.
  cpu              = "host"  # CPU to emulate: See https://pve.proxmox.com/pve-docs/chapter-qm.html#qm_cpu
  hagroup          = var.proxmox_node_config.vm_group  # VM group label to use
  ##########
  # Sizing #
  ##########
  memory           = var.proxmox_node_config.memory  # Memory in Megabytes
  balloon          = var.proxmox_node_config.memory_min  # Minimum memory in Megabytes, used for auto allocation
  sockets          = var.proxmox_node_config.sockets  # The number of sockets
  cores            = var.proxmox_node_config.cores  # Cores per socket
  pool             = var.proxmox_node_config.resource_pool  # proxmox resource pool to add node to

  #########################
  # Network Configuration #
  #########################
  network {
    model            = "virtio"
    bridge           = var.proxmox_node_config.network_name
  }

  ######################
  # Disk Configuration #
  ######################
  disk {
    type             = "virtio"
    storage          = var.proxmox_node_config.storage_pool
    size             = "10G"
  }

  ############################
  # Cloud init Configuration #
  ############################
  os_type          = "cloud-init"  # centos, cloud-init
  clone            = var.proxmox_node_config.vm_template  # VM Template to use
  full_clone       = false  # Turn off for linked clones (TODO: Research viability)
  ciuser     = var.proxmox_node_config.ssh_username
  sshkeys    = <<EOF
${var.proxmox_node_config.ssh_authorized_key}
EOF
  # ipconfig0
}