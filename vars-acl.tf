
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

variable "roles" {
    type = list(object({
        role_id = string
        privileges = list(string)
    }))
    description = "This is a list of roles, each with a `role_id` and associated set of privileges; these will be built in addition to a standard set."
    default     = []
}