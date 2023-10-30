# # This creates a role with the given properties and attributes.
# variable "role_name" {
#     description = "Cluster Role Name"
#     sensitive   = false
# }

# variable "role_id" {
#     description = "short-description-of-role"
#     sensitive   = false
# }

# variable "role_privileges" {
#     # type - This argument specifies what value types are accepted for the variable.
#     description = "A list of privileges to provide."
#     # validation - A block to define validation rules, usually in addition to type constraints.
#     # sensitive - Limits Terraform UI output when the variable is used in configuration.
#     nullable    = false
# }

# resource "proxmox_virtual_environment_role" "deployed_role" {
#   name       = "${var.role_name}"
#   role_id    = "${var.role_id}"
#   privileges = var.privileges
# }