####################################################################
#                    Default Machine Definitions                   #
# ---------------------------------------------------------------- #
# This module deploys some pre-baked recipes, collected and        #
#   organized relatively nicely.                                   #
####################################################################
locals {
  machine_definitions = {
    for index, machine_definition in module.module.machine_definitions.machine_input_defaults:
    machine_definition["machine_type"] => machine_definition
  }
}
output "machine_input_defaults" {
    description = "Default machine inputs to create VMs."
    sensitive   = false
    value       = [
        # Gaming VM.
        var.vm-config-gaming,
        # K8s role
        var.vm-config-k8s-node,
        # Machine definitions
        local.machine_definitions
    ]
}