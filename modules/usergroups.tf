####################################################################
#                            UserGroups                            #
# ---------------------------------------------------------------- #
# This deploys groups and users into a proxmox cluster.            #
####################################################################
# groups: (exposes .members)
#  * acl - (Optional) The access control list (multiple blocks supported).
#    * path - The path.
#    * propagate - Whether to propagate to child paths.
#    * role_id - The role identifier.
#  * group_id
#  * comment
# users:
#  * acl - (Optional) The access control list (multiple blocks supported).
#    * path - The path.
#    * propagate - Whether to propagate to child paths.
#    * role_id - The role identifier.
#  * comment
#  * email
#  * enabled
#  * expiration_date
#  * first_name
#  * groups
#  * keys
#  * last_name
#  * password
#  * user_id
variable "groups" {
    type = list(map(string))
    description = "This is a list of groups, each with a `description` and a `name`"
}

# Create groups; looping over inputs
resource "proxmox_virtual_environment_group" "fixed_compute_groups" {
    for_each = {for index, _mapping in var.groups : index => _mapping}
    comment  = each.value["description"]
    group_id = each.value["name"]
}


variable "users" {
    type = list(object({
        username = string
        domains = list(string)
        comment = string
        email = string
        enabled = bool
        expiration = string
        firstname = string
        lastname = string
        groups = list(string)
        keys = string
        ssh_public_key = string
        ssh_private_key = string
        acl = string
    }))
}

# Create users; looping over inputs
resource "proxmox_virtual_environment_user" "fixed_compute_users" {
    depends_on      = [ resource.proxmox_virtual_environment_group.fixed_compute_groups ]
    for_each        = {for index, _mapping in var.users : index => _mapping}
    comment         = each.value["comment"]
    email           = each.value["email"]
    enabled         = each.value["enabled"]
    expiration_date = each.value["expiration"]
    first_name      = each.value["firstname"]
    groups          = each.value["groups"]
    keys            = each.value["keys"]
    last_name       = each.value["lastname"]
    # No one gets access by default.
    password        = null
    user_id         = each.value["username"]

}
