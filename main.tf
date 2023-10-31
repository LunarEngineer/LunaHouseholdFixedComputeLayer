
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

variable "groups" {
    type = list(map(string))
    description = "This is a list of groups, each with a `description` and a `name`"
}

module "fixed_compute_layer_usergroups" {
  source              = "./modules"
  # Shape and structure inputs
  users               = var.users
  groups              = var.groups
}
