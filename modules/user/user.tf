
# variable "username" {
#     type = str
# }

# variable "domain" {
#     description = "pve e.g."
#     type = str
# }

# variable "comment" {
#     type = str
#     description = "A free-text description of the user."
# }

# variable "email" {
#     type = str
#     description = "A user email address."
# }

# variable "enabled" {
#     type = bool
#     description = "Whether the user is enabled"
#     default = true
# }

# variable "expiration" {
#     type = date
#     description = "When the user will expire"
#     default = null
# }

# variable "firstname" {
#     type = string
#     description = "First name"
# }

# variable "lastname" {
#     type = string
#     description = "Last name"
# }
# # All users are 2fa. No passwords. Ever.

# variable "groups" {
#     type = list(str)
#     description = "List of groups to associate with user."
#     default = null
# }

# variable "keys" {
#     type = str
#     description = "User keys"  # WHY?
#     default = null
# }


# variable "ssh_private_key" {
#     default     = null
#     # type - This argument specifies what value types are accepted for the variable.
#     description = "A path to a private key file."
#     # validation - A block to define validation rules, usually in addition to type constraints.
#     # sensitive - Limits Terraform UI output when the variable is used in configuration.
#     nullable    = false
# }
# variable "ssh_public_key" {
#     default     = null
#     # type - This argument specifies what value types are accepted for the variable.
#     description = "A path to a public key file."
#     # validation - A block to define validation rules, usually in addition to type constraints.
#     # sensitive - Limits Terraform UI output when the variable is used in configuration.
#     nullable    = false
# }
# locals {
#   passed_public_key  = var.ssh_public_key  == null ? true : false
#   passed_private_key = var.ssh_private_key == null ? true : false
# }

# If NEITHER was passed.
# resource "tls_private_key" "bootstrap_temporary_key" {
#   # If neither key was passed, this is created.
#   # This key will be short lived.
#   count = local.passed_private_key == false && local.passed_public_key == false
#   algorithm = "ED25519"
# }
# If someone was silly enough to pass a public, but not a private, or vv
# 'Do you want to explode!?'
# resource "null_resource" "key_validation" {
#     count = local.passed_private_key == null || local.passed_public_key

#     provisioner "local-exec" {
#       command = "echo 'If providing a keypair provide both files.' && exit 1"
#     }
# }
# variable "acl" {
    # type = who the fuck knows
    # acl - (Optional) The access control list (multiple blocks supported).
    #     path - The path.
    #     propagate - Whether to propagate to child paths.
    #     role_id - The role identifier.
#   acl {
#     # Paths here include vm, storage, network (/sdn/vnets/{vnet})
#     path      = "/vms/1234"
#     propagate = true
#     role_id   = proxmox_virtual_environment_role.operations_monitoring.role_id
#   }
# }

# resource "proxmox_virtual_environment_user" "deployed_user" {
#     name            = "bob"
#     comment         = vars.comment
#     user_id         = "${vars.username}@${vars.domain}"
#     # acl             = vars.acl
#     email           = vars.email
#     enabled         = vars.enabled
#     expiration_date = vars.expiration
#     first_name      = vars.first_name
#     groups          = vars.groups
#     keys            = vars.keys
#     last_name       = vars.last_name
# }

####################################################################
#                            Security                              #
# ---------------------------------------------------------------- #
# Each user is assigned a new, independent, explicitly secure, key.#
# That key is stored within a vault and used for validation.       #
# Each user is also provided with a self-signed certificate if they#
#   do not bring their own.                                        #
# For 'internally supplied' security there's a time window.        #
####################################################################
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key


# Finally, if both were passed... Great!
# A bootstrap key exposes
# * id (String) Unique identifier for this resource: hexadecimal representation of the SHA1 checksum of the resource.
# * private_key_openssh (String, Sensitive) Private key data in OpenSSH PEM (RFC 4716) format.
# * private_key_pem (String, Sensitive) Private key data in PEM (RFC 1421) format.
# * private_key_pem_pkcs8 (String, Sensitive) Private key data in PKCS#8 PEM (RFC 5208) format.
# * public_key_fingerprint_md5 (String) The fingerprint of the public key data in OpenSSH MD5 hash format, e.g. aa:bb:cc:.... Only available if the selected private key format is compatible, similarly to public_key_openssh and the ECDSA P224 limitations.
# * public_key_fingerprint_sha256 (String) The fingerprint of the public key data in OpenSSH SHA256 hash format, e.g. SHA256:.... Only available if the selected private key format is compatible, similarly to public_key_openssh and the ECDSA P224 limitations.
# * public_key_openssh (String) The public key data in "Authorized Keys" format. This is not populated for ECDSA with curve P224, as it is not supported. NOTE: the underlying libraries that generate this value append a \n at the end of the PEM. In case this disrupts your use case, we recommend using trimspace().
# * public_key_pem (String) Public key data in PEM (RFC 1421) format. NOTE: the underlying libraries that generate this value append a \n at the end of the PEM. In case this disrupts your use case, we recommend using trimspace().
