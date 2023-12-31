# LunaHouseholdFixedComputeLayer

Or 'Cloud-in-a-Can'.

This deploys users, groups, and roles.

Then, this builds some preset 'flavors' for secure VMs:
* k8s node (Because I need a k8s cluster) for my funtimes.
* Gaming VM (Because I still enjoy having fun, and my laptop isn't a smooth experience)

The goal is to have it as automated as possible, with as few HITL interactions as possible.


## Updates

I am adapting this to the new provider.

1. Swap provider: DONE
2. a: Accomodate all the required provider changes. DONE?
2. List provider new resources. DONE
  a. local DNS config in network (handy for host mapping of names to ips)
  b. Cloud config file: Put it in the ceph cluster? - https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file
  c. output alias in this firewall group and ipset
  d. think about firewall options:
  e. think about users and groups.
3. Write down extractable patterns which can be reusable.
4. [Implement certificate authority and get rid of self-signed certs.](https://amod-kadam.medium.com/create-private-ca-and-certificates-using-terraform-4b0be8d1e86d)
5. Build users for lunahousehold and for bootstrapping. 

Plan for Output:

This deploys a 'cloud in a can' ready to be reused dependent on an input dataset.

This input dataset, given in a tabular dataset, produces an output set of vms across the dataset.
This deploys users, groups, roles, etc.

This outputs the data structure representative of the cloud, with metadata defining all elements deployed.

{'node', 'vm stuff', 'e.g.'}

Each of these nodes will deploy according to the input. So, what needs to be abstracted?

1. Users. Each cloud will have a list of users. Those users will be created on each node.
2. Group. Each cloud deploys a group for the users. That group will be created on each node.x
3. Network and Firewall Rules. This will explicitly declare the network and firewall rules. This will need to be passed the information at some point to expose the k8s network.
4. Network information: This will ensure that local DNS configuration is appropriate.
5. Cloud Config: It's honestly really cool. You should try it, really.

Working on this currently in data_elements.tf troubleshooting modules / network config

### Provider Requirements

The provider requires an API token and an SSH key.

The SSH key is generated here and persisted as both input and output; both the private and public key are stored as attrbiutes.

The API token must be generated by you.

I dorked around with authy 2fa totp here. we'll see if I need to remove it.

# TOOD: Scrape high level explanation of inputs

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

