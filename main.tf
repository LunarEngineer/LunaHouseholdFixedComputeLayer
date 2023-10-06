#######################
# Fixed Compute Layer #
#######################
# This deploys a k8s node.

resource "proxmox_vm_qemu" "k8s_node" {
  # depends_on = [local_sensitive_file.ssh_private_key]
  name             = "k8s-node-${var.proxmox_node_config.role}-${var.proxmox_node_config.target_node}"
  target_node      = var.proxmox_node_config.target_node # Specify the Proxmox cluster node
  vmid             = 0  # VM ID are assigned automatically.
  desc             = var.proxmox_node_config.description  # General description of the node.
  provider         = proxmox  # Pass in the provider information
  onboot           = true  # Turn on when the node is on.
  oncreate         = true  # Turn on when deployed.
  tablet           = false  # Turn on tablet device (needed for mouse)
  agent            = 1  # Turn on the qemu agent (TODO: do not forget to enable the daemon)
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
  os_network_config = <<EOF
auto eth0
iface eth0 inet dhcp
EOF
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
  full_clone       = false  # Full clones take much more time and are unnecessary.
  ciuser           = var.proxmox_node_config.ssh_username  #
  ssh_user         = var.proxmox_node_config.ssh_username
  ssh_private_key  = var.proxmox_node_config.ssh_private_key
  sshkeys          = <<EOF
${var.proxmox_node_config.ssh_public_key}
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
      "sudo apt-get install qemu-guest-agent",
      "sudo systemctl start qemu-guest-agent",
      "sudo systemctl enable qemu-guest-agent",
      # count.index == 0
      # ? "echo 'Running setup script on ${self.triggers.node_name}' && ./setup_script.sh"
      # : "echo 'Running cluster join command on ${self.triggers.node_name}' && ./join_cluster.sh ${null_resource.k8s_nodes[0].triggers.node_ip}"
    ]
  }
}