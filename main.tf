#######################
# Fixed Compute Layer #
#######################
# This deploys a k8s network.

###############
# Master Node #
###############
# This contains a resource and a data element.
# The resource deploys the master k8s node and then schleps the k8s join command down.
resource "proxmox_vm_qemu" "k8s_master" {
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
  cipassword       = "test"  # TODO: Remove when things are fully functional.
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

# Extracted from k8s_master
# provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = self.ssh_user
#       private_key = self.ssh_private_key
#       host        = self.default_ipv4_address
#     }
#     inline = [
#       # Wait for snap availability
#       "sudo snap wait system seed.loaded",
#       # Install k8s
#       "sudo snap install microk8s --classic",
#       "sudo usermod -a -G microk8s terraform-prov",
#       "sudo chown -R terraform-prov ~/",
#       "echo \"exit\" | newgrp microk8s",
#       "echo microk8s installed",
#     ]
#   }

#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = self.ssh_user
#       private_key = self.ssh_private_key
#       host        = self.default_ipv4_address
#     }
#     inline = [
#       "echo providing user with microk8s group",
#       "sudo usermod -a -G microk8s terraform-prov",
#       "sudo chown -R terraform-prov ~/",
#       "echo \"exit\" | newgrp microk8s",
#       # Export the k8s join and k8s config
#       "echo \"$(microk8s add-node | grep microk8s | head -n 1) --skip-verify\" > /tmp/k8s-join",
#       "echo done",
#     ]
#   }
#   provisioner "local-exec" {
#     command = templatefile(
#       "${path.module}/get_join_str.sh.tftpl",
#       {
#         ssh_private_key=var.ssh_private_key,
#         keyname = "k8s-join-master-key",
#         ssh_user = var.ssh_username,
#         ip = self.default_ipv4_address
#       }
#     )
#   }

# data "local_file" "cluster-join" {
#   depends_on = [ proxmox_vm_qemu.k8s_master ]
#   filename = "k8s-join"
# }

#################
# Control Nodes #
#################
# This deploys a series of control nodes.
resource "proxmox_vm_qemu" "k8s_control_nodes" {
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
  cipassword       = "test"  # TODO: Remove when complete
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

# Extracted from control node
# provisioner "remote-exec" {
#   connection {
#     type        = "ssh"
#     user        = self.ssh_user
#     private_key = self.ssh_private_key
#     host        = self.default_ipv4_address
#   }
#   inline = [
#     # Wait for snap availability
#     "sudo snap wait system seed.loaded",
#     # Install k8s
#     "sudo snap install microk8s --classic",
#     "sudo usermod -a -G microk8s terraform-prov",
#     "sudo chown -R terraform-prov ~/",
#     "echo \"exit\" | newgrp microk8s",
#     "echo microk8s installed",
#   ]
# }

# provisioner "remote-exec" {
#   connection {
#     type        = "ssh"
#     user        = self.ssh_user
#     private_key = self.ssh_private_key
#     host        = self.default_ipv4_address
#   }
#   inline = [
#     "echo providing user with microk8s group",
#     "sudo usermod -a -G microk8s terraform-prov",
#     "sudo chown -R terraform-prov ~/",
#     # Join the cluster
#     "${data.local_file.cluster-join.content}",
#     "echo done",
#   ]
# }

# Useful testing commands
# export MASTER_NODE_IP="192.168.50.12"
# export CONTROL_NODE_IP="192.168.50.111"
# Connection failed. The hostname (k8s-node-control-gaianode01) of the joining node does not resolve to the IP "192.168.50.125". Refusing join (400)
# ssh terraform-prov@$MASTER_NODE_IP -i k8s-join-master-key
# Add this line to the /etc/hosts
#192.168.50.117 k8s-node-control-gaianode01
# ssh terraform-prov@$CONTROL_NODE_IP -i k8s-join-master-key
# microk8s join 192.168.50.176:25000/2f0cefed4aba6948c73134880ddb1ec7/0ff44d85c1dd