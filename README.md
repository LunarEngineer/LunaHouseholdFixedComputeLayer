# LunaHouseholdFixedComputeLayer

## Updates

I am adapting this to the new provider.

1. Swap provider
2. List provider new resources.
3. Write down extractable patterns which can be reusable.

## Old stuff

This deploys a series of proxmox nodes into an expected output structure.

known issues: Flaky-ass provider; resolution - cancel apply, murder and delete failues, reapply. 5 min apply on average. ideal final solution - provider swap **or** automate around failures and ensure recording time metrics for comparison

## Contents

This uses the environment variables `PM_API_URL`, `PM_API_TOKEN_SECRET`, and `PM_API_TOKEN_ID` (or other appropriate credentials) to define connectivity for the provider.

There are four files here:
* [`vars.tf`](vars.tf)`: This contains the following data structures:
  * k8s_nodes: A three {str: list[str]} mappings which declare the set(s) of master, control, and worker VMs to create by denoting their **target** *proxmox node*. (See example below)
  * ssh_*: Three variables containing various SSH credential information.
  * *_plane_node_args: Two mappings with mildly different default values for the QEmu VMs.
* [`versions.tf`](versions.tf): Simply declaring the required Telmate provider.
* [`main.tf`](main.tf): This deploys three sets of QEmu VMs into the proxmox cluster (master, control, worker).
* [`output.tf`](output.tf): This contains *three* key-value 'VM Name' to 'VM IP' output data structures identifying the contact information for the deployed VMs.

On the far side of this is a set of managed vms in a few groups.

## Example

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

