####################################################################
#         This implements security, access, and control.           #
####################################################################
# Initially there is only the service role deployed into each node.
# That service role is called 'fixed compute worker' or similiar.
# That service role is within the group 'fixed compute maintainer' or similar.
# There is a concurrent role deployed into the cluster of 'fixed compute maintainer' or similar.
# Finally, there is a self-signed certificate deployed. 'I am who I say I am, trust me.'
# At some point it will be worthwhile to investigate a high volume external certificate authority.
#######################
# Fixed Compute Layer #
#######################

# module "fixed_compute_layer" {
#   source              = "./LunaHouseholdFixedComputeLayer"
#   pm_api_user         = module.secrets_engine.pm_api_user
#   pm_api_port         = module.secrets_engine.pm_api_port
#   pm_api_ip           = module.secrets_engine.pm_api_ip
#   pm_api_token_id     = module.secrets_engine.pm_api_token_id
#   pm_api_token_secret = module.secrets_engine.pm_api_token_secret
#   providers           = {
#     proxmox = proxmox
#   }
# }


# ORganization
# Node cert
# user > group > role (Deployed in reverse!)
####################################################################
#                             Inputs                               #
# ---------------------------------------------------------------- #
# This gives a username (mandatory) and potentially provides an ssh#
#   key and / or certificate.                                      #
# Documentation for terraform variable input values and types
# https://developer.hashicorp.com/terraform/language/values/variables#arguments
####################################################################

# variable "certificateshit" {
#     default     = "GENERATE"
#     # type - This argument specifies what value types are accepted for the variable.
#     description = "I dunno, I'll figure it out."
#     # validation - A block to define validation rules, usually in addition to type constraints.
#     # sensitive - Limits Terraform UI output when the variable is used in configuration.
#     nullable    = false
# }





####################################################################
#                      Access Control List                         #
# ---------------------------------------------------------------- #
# This section takes the input user data structure and creates     #
#   users. Each of these users is considered an independent entity #
#   within the cluster, meaning that they are associated with data #
#   and an *external source of compute*. As such, they are given a #
#   limited role.                                                  #
# ---------------------------------------------------------------- #
# This part is lifted to the creation of the input data structure logic.
# These rules will be used to rigorously define and guarantee security.
# A user is created for local maintenance on each node with very   #
#   specific limited sets of accesses that clearly and explicitly  #
#   do not overlap with the maintainer role.                       #
# A user is created for local security monitoring / measure ditto. #
####################################################################
####################################################################
#                             Inputs                               #
# ---------------------------------------------------------------- #
# This gives a role name and a set of privileges.
# Documentation for terraform variable input values and types
# https://developer.hashicorp.com/terraform/language/values/variables#arguments
####################################################################


# This is for read only access to logs and state
# This 





# Replace these with calls to the role module reusing the privilege data structure / inputs..
# resource "proxmox_virtual_environment_role" "bootstrap" {
#   role_id = "cluster-bootstrap"

#   privileges = var.bootstrap_privileges
# }

# resource "proxmox_virtual_environment_role" "cluster-maintenance" {
#   role_id = "cluster-maintenance"

#   privileges = var.cluster_maintenance_privileges
# }

# resource "proxmox_virtual_environment_role" "node-maintenance" {
#   role_id = "node-maintenance"

#   privileges = var.cluster_node_maintenance
# }

# resource "proxmox_virtual_environment_role" "node-user" {
#   role_id = "node-user"

#   privileges = var.user_level_privileges
# }


# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_user



# What does a user need access to?
# 1. VMS under shared and personal space.


# Next up here is deploying groups, then users in groups.

# resource "proxmox_virtual_environment_group" "operations_team" {
#   comment  = "Managed by Terraform"
#   group_id = "operations-team"
# }

# Think...
# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_group

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_role

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_user

# This outputs a formatted data structure which clearly and succintly describes the deployed structure in metadata
# This outputs the username.
# This outputs the filepaths for the keyfiles.
# This outputs the filepaths for the certificats.