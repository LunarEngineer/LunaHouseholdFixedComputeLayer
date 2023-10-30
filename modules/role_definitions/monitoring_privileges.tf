# # Explicitly declare the privileges associated with the monitoring role.

# variable "cluster_monitoring_privileges" {
#     type = list(str)
#     default = [
#         # "Mapping.Audit",  # Need to be able to view resources.
#         # "Pool.Audit",  # Need to view pools.
#         # "SDN.Audit",  # Need to view networks.
#         # "SYS.Audit",  # WHY.
#         # "VM.Audit",  # View VM config.
#         # "Datastore.Audit"  # View data stores.
#     ]
# }