# Describe the cluster!

# Get nodes.
data "proxmox_virtual_environment_nodes" "available_nodes" {}

# Get data stores on each node. (Needs to be 'distinct-ed')
data "proxmox_virtual_environment_datastores" "available_datastores" {
    for_each  = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
    node_name = each.key
}

# Publish labeled machine images

output "lookatmenodes" {
    description = "Information on the nodes."
    sensitive   = false
    value       = {
        "nodes": data.proxmox_virtual_environment_nodes.available_nodes,
        "datastores": data.proxmox_virtual_environment_datastores.available_datastores,
        "available_machine_types": "none"
    }
}