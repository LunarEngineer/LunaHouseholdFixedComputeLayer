#####################
# Master IP         #
# Control Plane IPs #
# Worker Plane IPs  #
#####################

output "master_ip" {
  value = resource.proxmox_vm_qemu.k8s_master[var.k8s_nodes.k8s_nodes_master[0]].default_ipv4_address
}

output "control_plane_ips" {
  value = { for vm in resource.proxmox_vm_qemu.k8s_control: vm.name => vm.default_ipv4_address }
}

output "worker_plane_ips" {
  value = { for vm in resource.proxmox_vm_qemu.k8s_worker: vm.name => vm.default_ipv4_address }
}