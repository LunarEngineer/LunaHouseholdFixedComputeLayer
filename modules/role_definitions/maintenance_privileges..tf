# variable "cluster_security_maintenance" {
#     # Inherit monitoring
#     type = list(str)
#     default = concat([
#         # "User.Modify",  # Add Users / Modify Users
#         # "Permissions.Modify",  # Change permissions for sets of users.
#         # "Realm.AllocateUser",  # Add users to realm.
#         # "Realm.Allocate",  # Create realms
#     ], var.cluster_monitoring_privileges)
# }

# variable "cluster_node_maintenance" {
#     # Inherit monitoring
#     type = list(str)
#     default = concat([
#         # "VM.Audit",  # View VM config (monitor)
#         # "VM.Backup",  # Backup a VM.
#         # "VM.Config.CPU",  # Configure CPU limitations.
#         # "VM.Config.Disk",  # Configure VM disk.
#         # "VM.Config.Memory",  # Configure VM Memory
#         # "VM.Config.Network",  # Configure VM Network
#         # "VM.Config.Options",  # Configure VM options.
#         # "VM.Snapshot.Rollback",  # Rollback to previous snapshot
#         # "VM.Snapshot",  # Create and delete snapshots.
#         # "Datastore.Allocate",  # Volume maintenance
#         # "Datastore.AllocateSpace",  # Volume maintenance
#         # "Datastore.Audit",  # View data stores.
#     ], var.cluster_monitoring_privileges)
# }

# variable "cluster_network_maintenance" {
#     type = list(str)
#     default = [
#         # "SDN.Allocate",  # Need for making networks.
#         # "Sys.Modify",  # Need for asssigning network params to nodes.
#         # "VM.Config.Network",  # Need for enforcing network adherence.
#     ]
# }

# variable "cluster_maintenance_privileges" {
#     type = list(str)
#     default = concat([
#         # This should inherit the set of cluster monitoring privileges
#         "Mapping.Modify",  # Should be able to re / deprovision access to things.
#         "Mapping.Use",  # WHY
#         # This should inherit the cluster security privileges?
#         "Pool.Allocate",  # Create pools
#         # This should inherit network maintenance mask


#     ], cluster_network_maintenance, cluster_security_maintenance, cluster_monitoring_privileges)
# }
