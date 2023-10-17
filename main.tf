#######################
# Fixed Compute Layer #
#######################
# This deploys the backbone for a k8s network.
# TODO: Take the pattern below and abstract it.

###############
# Master Node #
###############
resource "proxmox_vm_qemu" "k8s_master" {
  lifecycle {
    ignore_changes = [ qemu_os, pool, disk ]
  }
  for_each = { for name in var.k8s_nodes.k8s_nodes_master : name => name }
  target_node      = each.value
  name             = "k8s-node-root-${each.value}"
  vmid             = 0  # VM ID are assigned automatically.
  desc             = var.control_plane_node_args.description  # General description of the node.
  provider         = proxmox  # Pass in the provider information
  onboot           = true  # Turn on when the node is on.
  oncreate         = true  # Turn on when deployed.
  tablet           = false  # Turn on tablet device (needed for mouse)
  agent            = 1  # Turn on the qemu agent (TODO: do not forget to enable the daemon)
  hastate          = "started"  # On and ready to go.
  cpu              = "host"  # CPU to emulate: See https://pve.proxmox.com/pve-docs/chapter-qm.html#qm_cpu
  hagroup          = var.control_plane_node_args.vm_group  # VM group label to use
  ##########
  # Sizing #
  ##########
  memory           = var.control_plane_node_args.memory  # Memory in Megabytes
  balloon          = var.control_plane_node_args.memory_min  # Minimum memory in Megabytes, used for auto allocation
  sockets          = var.control_plane_node_args.sockets  # The number of sockets
  cores            = var.control_plane_node_args.cores  # Cores per socket
  pool             = var.control_plane_node_args.resource_pool  # proxmox resource pool to add node to

  #########################
  # Network Configuration #
  #########################
  network {
    model            = "virtio"
    bridge           = var.control_plane_node_args.network_name
  }
  os_network_config = <<EOF
auto eth0
iface eth0 inet dhcp
EOF
  ######################
  # Disk Configuration #
  ######################
  disk {
    type             = "virtio"
    storage          = var.control_plane_node_args.storage_pool
    size             = "10G"
  }

  ############################
  # Cloud init Configuration #
  ############################
  os_type          = "cloud-init"  # centos, cloud-init
  clone            = var.control_plane_node_args.vm_template  # VM Template to use
  full_clone       = false  # Full clones take much more time and are unnecessary.
  ciuser           = var.ssh_username  #
  ssh_user         = var.ssh_username
  ssh_private_key  = var.ssh_private_key
  sshkeys          = <<EOF
${var.ssh_public_key}
EOF
  ipconfig0          = "ip=dhcp"
  

  ##################
  # Instance Setup #
  ##################
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = self.ssh_user
      private_key = self.ssh_private_key
      host        = self.default_ipv4_address
    }

    inline = [
      "#!/bin/bash",
      # Turn on the guest agent to allow IP information to flow
      "sudo apt-get install qemu-guest-agent",
      "sudo systemctl start qemu-guest-agent",
      # "sudo systemctl enable qemu-guest-agent",
    ]
  }
}


#################
# Control Nodes #
#################
# This deploys a series of control nodes.
resource "proxmox_vm_qemu" "k8s_control" {
  lifecycle {
    ignore_changes = [ qemu_os, pool, disk ]
  }
  depends_on = [ resource.proxmox_vm_qemu.k8s_master ]
  for_each = { for name in var.k8s_nodes.k8s_nodes_control : name => name }
  target_node      = each.value
  name             = "k8s-node-control-${each.value}"
  vmid             = 0  # VM ID are assigned automatically.
  desc             = var.control_plane_node_args.description  # General description of the node.
  provider         = proxmox  # Pass in the provider information
  onboot           = true  # Turn on when the node is on.
  oncreate         = true  # Turn on when deployed.
  tablet           = false  # Turn on tablet device (needed for mouse)
  agent            = 1  # Turn on the qemu agent (TODO: do not forget to enable the daemon)
  hastate          = "started"  # On and ready to go.
  cpu              = "host"  # CPU to emulate: See https://pve.proxmox.com/pve-docs/chapter-qm.html#qm_cpu
  hagroup          = var.control_plane_node_args.vm_group  # VM group label to use
  ##########
  # Sizing #
  ##########
  memory           = var.control_plane_node_args.memory  # Memory in Megabytes
  balloon          = var.control_plane_node_args.memory_min  # Minimum memory in Megabytes, used for auto allocation
  sockets          = var.control_plane_node_args.sockets  # The number of sockets
  cores            = var.control_plane_node_args.cores  # Cores per socket
  pool             = var.control_plane_node_args.resource_pool  # proxmox resource pool to add node to

  #########################
  # Network Configuration #
  #########################
  network {
    model            = "virtio"
    bridge           = var.control_plane_node_args.network_name
  }
  os_network_config = <<EOF
auto eth0
iface eth0 inet dhcp
EOF
  ######################
  # Disk Configuration #
  ######################
  disk {
    type             = "virtio"
    storage          = var.control_plane_node_args.storage_pool
    size             = "10G"
  }

  ############################
  # Cloud init Configuration #
  ############################
  os_type          = "cloud-init"  # centos, cloud-init
  clone            = var.control_plane_node_args.vm_template  # VM Template to use
  full_clone       = false  # Full clones take much more time and are unnecessary.
  ciuser           = var.ssh_username  #
  ssh_user         = var.ssh_username
  ssh_private_key  = var.ssh_private_key
  sshkeys          = <<EOF
${var.ssh_public_key}
EOF
  ipconfig0          = "ip=dhcp"
  

  ##################
  # Instance Setup #
  ##################
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = self.ssh_user
      private_key = self.ssh_private_key
      host        = self.default_ipv4_address
    }

    inline = [
      "#!/bin/bash",
      # Turn on the guest agent to allow IP information to flow
      "sudo apt-get install qemu-guest-agent",
      "sudo systemctl start qemu-guest-agent",
      # "sudo systemctl enable qemu-guest-agent",
    ]
  }
}

################
# Worker Nodes #
################
# The resource a series of worker nodes.
resource "proxmox_vm_qemu" "k8s_worker" {
  lifecycle {
    ignore_changes = [ qemu_os, pool, disk ]
  }
  depends_on = [ resource.proxmox_vm_qemu.k8s_control ]
  for_each = { for name in var.k8s_nodes.k8s_nodes_worker : name => name }
  target_node      = each.value
  name             = "k8s-node-worker-${each.value}"
  vmid             = 0  # VM ID are assigned automatically.
  desc             = var.worker_plane_node_args.description  # General description of the node.
  provider         = proxmox  # Pass in the provider information
  onboot           = true  # Turn on when the node is on.
  oncreate         = true  # Turn on when deployed.
  tablet           = false  # Turn on tablet device (needed for mouse)
  agent            = 1  # Turn on the qemu agent (TODO: do not forget to enable the daemon)
  hastate          = "started"  # On and ready to go.
  cpu              = "host"  # CPU to emulate: See https://pve.proxmox.com/pve-docs/chapter-qm.html#qm_cpu
  hagroup          = var.worker_plane_node_args.vm_group  # VM group label to use
  ##########
  # Sizing #
  ##########
  memory           = var.worker_plane_node_args.memory  # Memory in Megabytes
  balloon          = var.worker_plane_node_args.memory_min  # Minimum memory in Megabytes, used for auto allocation
  sockets          = var.worker_plane_node_args.sockets  # The number of sockets
  cores            = var.worker_plane_node_args.cores  # Cores per socket
  pool             = var.worker_plane_node_args.resource_pool  # proxmox resource pool to add node to

  #########################
  # Network Configuration #
  #########################
  network {
    model            = "virtio"
    bridge           = var.worker_plane_node_args.network_name
  }
  os_network_config = <<EOF
auto eth0
iface eth0 inet dhcp
EOF
  ######################
  # Disk Configuration #
  ######################
  disk {
    type             = "virtio"
    storage          = var.worker_plane_node_args.storage_pool
    size             = "10G"
  }

  ############################
  # Cloud init Configuration #
  ############################
  os_type          = "cloud-init"  # centos, cloud-init
  clone            = var.worker_plane_node_args.vm_template  # VM Template to use
  full_clone       = false  # Full clones take much more time and are unnecessary.
  ciuser           = var.ssh_username  #
  ssh_user         = var.ssh_username
  ssh_private_key  = var.ssh_private_key
  sshkeys          = <<EOF
${var.ssh_public_key}
EOF
  ipconfig0          = "ip=dhcp"
  

  ##################
  # Instance Setup #
  ##################
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = self.ssh_user
      private_key = self.ssh_private_key
      host        = self.default_ipv4_address
    }

    inline = [
      "#!/bin/bash",
      # Turn on the guest agent to allow IP information to flow
      "sudo apt-get install qemu-guest-agent",
      "sudo systemctl start qemu-guest-agent",
      # "sudo systemctl enable qemu-guest-agent",
    ]
  }
}
