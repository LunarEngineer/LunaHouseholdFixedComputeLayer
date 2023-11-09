####################################################################
#                    Default Machine Definitions                   #
# ---------------------------------------------------------------- #
# This module deploys some pre-baked recipes, collected and        #
#   organized relatively nicely. At some point if there are a lot  #
#   of recipes it might be worth managing them.                    #
####################################################################
module "k8s_node" {
    source = "k8s-node"
}

module "gaming_vm" {
    source = "gaming-vm"
}

# Here we need to make a machine from either / both. For now expose both.
output "machine_input_defaults" {
    description = "Default machine inputs to create VMs."
    sensitive   = false
    value       = [
        # Gaming VM.
        module.gaming_vm.default_inputs,
        # K8s role
        module.k8s_node.default_inputs,
    ]
}




locals {
    compute_inputs = [
        {
            "compute_type": "gaming-vm", "ram": "32GB", "t_max": 0, "scale": "gaianode04", "requirements": {
                "user": "tim", 
                "gpu": true,
                "state": "off",
                "storage": {
                    "local-zfs": "local-zfs",
                    "steam-folder": "steam-folder"
                }
            }
        },
        {
            "compute_type": "dev-machine", "ram": "32GB", "t_max": 0, "scale": "gaianode04", "requirements": {
                "user": "tim", 
                "gpu": true,
                "state": "off",
                "storage": {
                    "local-zfs": "local-zfs",
                    "dev-mount": "dev-mount"
                }
            }
        },
        {
            "compute_type": "k8s-node", "ram": "2GB", "t_max": 0, "scale": "global", "requirements": {
                "user": "gaiak8s"
            }
        }
    ]
}

# What defines a Windows Gaming VM? user, software, hardware
# What defines a k8s node? user, software, hardware
#  both deploy a file if it doesn't exist.
# windows vm takes