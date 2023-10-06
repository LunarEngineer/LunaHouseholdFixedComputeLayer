output "ip" {
  description = "SSH Key for the server"
  sensitive   = true
  value       = resource.proxmox_vm_qemu.k8s_node.default_ipv4_address
}