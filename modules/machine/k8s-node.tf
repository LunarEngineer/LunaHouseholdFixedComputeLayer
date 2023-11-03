####################################################################
#                  K8s, it's what's for dinner.                    #
# ---------------------------------------------------------------- #
# This builds a linux VM with microk8s.                            #
# What does a VM need? It starts with a raw image, like an ISO.
variable "vm-config-k8s-node" {
    default = {
        "machine_type": "k8s-node",
        "machine_template": "http://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
    }
}


