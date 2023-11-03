####################################################################
#                      Deploy Standard VMs                         #
# ---------------------------------------------------------------- #
# This deploys standard recipe virtual machines using reusable     #
#   sets of input parameters.                                      #
####################################################################

# These are reusable sets that are 'flavor-appropriate'
module machine_definitions {
    source  = "./machine"
}


# Erry darn one of these contains a node to deploy to
variable "machines_to_create" {
    type = list(object({
        machine_type     = string,
    }))
}

# output "machine_input_defaults" {
#     value = module.machine_definitions.machine_input_defaults
# }

resource "proxmox_virtual_environment_file" "vm_iso" {
  content_type = "vztmpl"
  datastore_id = vars.datastore
  node_name    = vars.node

  source_file {
    path = "https://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
  }
}
