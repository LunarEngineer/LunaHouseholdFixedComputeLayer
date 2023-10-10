# LunaHouseholdFixedComputeLayer

This is the lowest layer of the LunaHousehold Server.

This deploys a k8s network into a series of proxmox nodes.

Just declare your proxmox nodes when you call the module.

i.e.

TODO: CODE FOLD HERE

```terraform
#######################
# Fixed Compute Layer #
#######################

variable "k8s_nodes_master" {
  type        = list(string)
  description = "A single proxmox node to be the master node."
  default     = ["gaianode00"]
}

variable "k8s_nodes_control" {
  type        = list(string)
  description = "A list of proxmox nodes to put control nodes on."
  default     = ["gaianode01", "gaianode02", "gaianode03"]
}

variable "k8s_nodes_worker" {
  type        = list(string)
  description = "A list of proxmox nodes to put worker nodes on."
  default     = ["gaianode00", "gaianode01", "gaianode02", "gaianode03"]
}


module "fixed_compute_layer_control_master" {
  source = "./LunaHouseholdFixedComputeLayer"
  k8s_nodes = {
    "k8s_nodes_master"  = var.k8s_nodes_master,
    "k8s_nodes_control" = var.k8s_nodes_control,
    "k8s_nodes_worker"  = var.k8s_nodes_worker
  }
  ssh_username    = module.secrets_engine.pm_api_user
  ssh_public_key  = module.secrets_engine.fixed_compute_public_key
  ssh_private_key = module.secrets_engine.fixed_compute_private_key
  providers = {
    proxmox = proxmox
  }
}
```

This uses the environment variables `PM_API_URL`, `PM_API_TOKEN_SECRET`, and `PM_API_TOKEN_ID` (or other appropriate credentials) to define connectivity for the provider.


Roadmap: Parameterization by start / join cluster and control / worker.
Roadmap: Get cloud-init yaml up and running or ansible. Looks like ansible takes care of both.