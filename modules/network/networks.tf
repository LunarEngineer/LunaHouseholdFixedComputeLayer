# ####################################################################
# #                        Network Definition                        #
# ####################################################################
# variable "networks" {
#     type    = list(list(string))
#     description = "Pairs of CIDR block and comments."
#     default = [
#         ["192.168.15.0/23", "LunaHouseholdTest"],
#         ["192.168.16.0/23", "LunaHouseholdProd"],
#         ["192.168.17.0/23", "LunarEngineeringTest"]
#     ]
# }
# proxmox_virtual_environment_firewall_ipset
# proxmox_virtual_environment_certificate
# tls_private_key
# tls_self_signed_cert
# proxmox_virtual_environment_dns
# proxmox_virtual_environment_hosts
# proxmox_virtual_environment_network_linux_bridge
# proxmox_virtual_environment_network_linux_vlan
# proxmox_virtual_environment_firewall_options
# proxmox_virtual_environment_firewall_rules
# proxmox_virtual_environment_firewall_alias
# virtual_environment_pool

# resource "proxmox_virtual_environment_firewall_ipset" "ipset" {
# # * node_name - (Optional) Node name. Leave empty for cluster level aliases.
# # * vm_id - (Optional) VM ID. Leave empty for cluster level aliases.
# # * container_id - (Optional) Container ID. Leave empty for cluster level aliases.
# # * name - (Required) IPSet name.
# # * comment - (Optional) IPSet comment.
# # * cidr - (Optional) IP/CIDR block (multiple blocks supported).
# #     * name - Network/IP specification in CIDR format.
# #     * comment - (Optional) Arbitrary string annotation.
# #     * nomatch - (Optional) Entries marked as nomatch are skipped as if those were not added to the set.
#     name    = "fixed_compute_layer_ipset"
#     comment = "Rules for traffic management."
#     dynamic "cidr" {
#         for_each = var.networks
#         content {
#             name    = cidr.value[0]
#             comment = cidr.value[1]
#         }
#     }
# }


# # Each node gets a TLS Self Signed Cert
# # This thing is just used for configuring, so it's dropped.

# # resource "proxmox_virtual_environment_certificate" "node_certificate" {
# #   certificate = tls_self_signed_cert.proxmox_virtual_environment_certificate.cert_pem
# #   node_name   = "first-node"
# #   private_key = tls_private_key.proxmox_virtual_environment_certificate.private_key_pem
# # }
# # resource "tls_private_key" "proxmox_virtual_environment_certificate" {
# #   algorithm = "RSA"
# #   rsa_bits  = 2048
# # }
# # resource "tls_self_signed_cert" "proxmox_virtual_environment_certificate" {
# #   key_algorithm   = tls_private_key.proxmox_virtual_environment_certificate.algorithm
# #   private_key_pem = tls_private_key.proxmox_virtual_environment_certificate.private_key_pem

# #   subject {
# #     common_name  = "example.com"
# #     organization = "Terraform Provider for Proxmox"
# #   }

# #   validity_period_hours = 2

# #   allowed_uses = [
# #     "key_encipherment",
# #     "digital_signature",
# #     "server_auth",
# #   ]
# # }
# # DNS Configuration - By node. This cannot be applied to groups.
# # resource "proxmox_virtual_environment_dns" "first_node_dns_configuration" {
# #   domain    = data.proxmox_virtual_environment_dns.first_node_dns_configuration.domain
# #   node_name = data.proxmox_virtual_environment_dns.first_node_dns_configuration.node_name

# #   servers = [
# #     "1.1.1.1",
# #     "1.0.0.1",
# #   ]
# # }
# # Hosts Configuration - By node. This cannot be applied to groups.
# # resource "proxmox_virtual_environment_hosts" "first_node_host_entries" {
# #   node_name = "first-node"

# #   entry {
# #     address = "127.0.0.1"

# #     hostnames = [
# #       "localhost",
# #       "localhost.localdomain",
# #     ]
# #   }
# # }
# # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_hosts
# # Virtual Network Bridge Configuration - By node. This cannot be applied to groups.
# # resource "proxmox_virtual_environment_network_linux_bridge" "vmbr99" {
# #   depends_on = [
# #     proxmox_virtual_environment_network_linux_vlan.vlan99
# #   ]

# #   node_name = "pve"
# #   name      = "vmbr99"

# #   address = "99.99.99.99/16"

# #   comment = "vmbr99 comment"

# #   ports = [
# #     "ens18.99"
# #   ]
# # }
# # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_network_linux_bridge
# # Virtual LAN Device Configuration - By node. This cannot be applied to groups.
# # using VLAN tag
# # resource "proxmox_virtual_environment_network_linux_vlan" "vlan99" {
# #   node_name = "pve"
# #   name      = "eno0.99"

# #   comment = "VLAN 99"
# # }
# # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_network_linux_vlan


# # resource "proxmox_virtual_environment_firewall_options" "example" {
# #   depends_on = [proxmox_virtual_environment_vm.example]

# #   node_name = proxmox_virtual_environment_vm.example.node_name
# #   vm_id     = proxmox_virtual_environment_vm.example.vm_id

# #   dhcp          = true
# #   enabled       = false
# #   ipfilter      = true
# #   log_level_in  = "info"
# #   log_level_out = "info"
# #   macfilter     = false
# #   ndp           = true
# #   input_policy  = "ACCEPT"
# #   output_policy = "ACCEPT"
# #   radv          = true
# # }

# # Think about this...
# # resource "proxmox_virtual_environment_firewall_rules" "inbound" {
# #   depends_on = [
# #     proxmox_virtual_environment_vm.example,
# #     proxmox_virtual_environment_cluster_firewall_security_group.example,
# #   ]
# #   Does not need node name
# #   node_name = proxmox_virtual_environment_vm.example.node_name
# #   vm_id     = proxmox_virtual_environment_vm.example.vm_id

# #   rule {
# #     type    = "in"
# #     action  = "ACCEPT"
# #     comment = "Allow HTTP"
# #     dest    = "192.168.1.5"
# #     dport   = "80"
# #     proto   = "tcp"
# #     log     = "info"
# #   }

# #   rule {
# #     type    = "in"
# #     action  = "ACCEPT"
# #     comment = "Allow HTTPS"
# #     dest    = "192.168.1.5"
# #     dport   = "443"
# #     proto   = "tcp"
# #     log     = "info"
# #   }

# #   rule {
# #     security_group = proxmox_virtual_environment_cluster_firewall_security_group.example.name
# #     comment        = "From security group"
# #     iface          = "net0"
# #   }
# # }
# # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_rules


# # # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_alias

# # Use this to name chunks of the network
# # resource "proxmox_virtual_environment_firewall_alias" "local_network" {
# #   depends_on = [proxmox_virtual_environment_vm.example]

# #   node_name = proxmox_virtual_environment_vm.example.node_name
# #   vm_id     = proxmox_virtual_environment_vm.example.vm_id

# #   name    = "local_network"
# #   cidr    = "192.168.0.0/23"
# #   comment = "Managed by Terraform"
# # }

# # resource "proxmox_virtual_environment_firewall_alias" "ubuntu_vm" {
# #   name    = "ubuntu"
# #   cidr    = "192.168.0.1"
# #   comment = "Managed by Terraform"
# # }

# # # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_ipset



# # # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_pool