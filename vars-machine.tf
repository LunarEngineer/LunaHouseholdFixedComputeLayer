# Declare input variables for machines
# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container
# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file
# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm

# Container image source: https://fleet.linuxserver.io/
# Ubuntu server image: https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-live-server-amd64.iso?_ga=2.263451534.383587817.1698864237-541913593.1674328413
# Windows vm: https://learn.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-terraform

# resource "proxmox_virtual_environment_file" "debian_container_template" {
#   content_type = "vztmpl"
#   datastore_id = "local"
#   node_name    = "first-node"

#   source_file {
#     path = "https://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
#   }
# }

# resource "proxmox_virtual_environment_file" "cloud_config" {
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = "pve"

#   source_raw {
#     data = <<EOF
# #cloud-config
# chpasswd:
#   list: |
#     ubuntu:example
#   expire: false
# hostname: example-hostname
# packages:
#   - qemu-guest-agent
# users:
#   - default
#   - name: ubuntu
#     groups: sudo
#     shell: /bin/bash
#     ssh-authorized-keys:
#       - ${trimspace(tls_private_key.example.public_key_openssh)}
#     sudo: ALL=(ALL) NOPASSWD:ALL
# EOF

#     file_name = "example.cloud-config.yaml"
#   }
# }
# variable "machine_name" {
#   description = "A *unique* name for the vm"
# }

# variable "machine_type" {
#   description     = "A pre-set template name"
#   type            = string
#   validation {
#     condition     = contains(output.lookatmenodes["available_machine_types"], var.machine_type)
#     error_message = "The value of var.example must be in ${output.lookatmenodes["available_machine_types"]}."
#   }
# }
# var "machine_definition" {
#   type = list(object(
#     machine_name
#   ))
# }