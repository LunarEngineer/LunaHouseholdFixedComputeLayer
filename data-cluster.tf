####################################################################
#                         Data Structures                          #
####################################################################

# This interacts with the proxmox cluster to return the set of nodes
#   in the cluster.
data "proxmox_virtual_environment_nodes" "available_nodes" {}

# Get data stores on each node. (Needs to be 'distinct-ed')
# This is a data structure with a by node mapping of data volumes.
data "proxmox_virtual_environment_datastores" "available_datastores" {
    for_each  = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
    node_name = each.key
}
# This is a data structure with a mapping of volumes to the nodes
#   upon which they are deployed. Note that local volumes named
#   identically will be 'present' on all the volumes, even though
#   in reality they are separate partitions.

# Publish labeled machine images

output "lookatmenodes" {
    description = "Information on the nodes."
    sensitive   = false
    value       = {
        "nodes": data.proxmox_virtual_environment_nodes.available_nodes,
        "datastores": data.proxmox_virtual_environment_datastores.available_datastores,
    }
}