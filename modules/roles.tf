####################################################################
#                               Roles                              #
# ---------------------------------------------------------------- #
# This deploys roles into a proxmox cluster.                       #
# It's broken into two sections: the first section builds default  #
#   role definitions and the second reuses those, along with any   #
#   passed, to make some roles.                                    #
####################################################################
# Default roles.
variable "roles" {
    type = list(object({
        role_id = string
        privileges = list(string)
    }))
    description = "This is a list of roles, each with a `role_id` and associated set of privileges."
    default     = []
}

module role_privileges {
    source  = "./role_definitions"
}

resource "proxmox_virtual_environment_role" "fixed_compute_roles" {
    for_each        = {for index, _mapping in concat(var.roles, module.role_privileges.default_roles) : _mapping["role_id"] => _mapping}
    role_id         = each.value["role_id"]
    privileges      = each.value["privileges"]
}