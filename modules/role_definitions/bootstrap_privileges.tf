# variable "bootstrap_privileges" {
#     type = list
#     default = concat([
#         # Listed below are 'most likely needed'
#         # "Group.Allocate",  # Need for bootstrap to create groups.
#         # "Mapping.Modify",  # WHY
#         # "Permissions.Modify",  # Need for bootstrap to assign privileges.
#         # "Pool.Allocate",  # Need for bootstrap to explicitly define pool of resources.
#         # "Realm.AllocateUser",  # Need for bootstrap to deploy users.
#         # "Realm.Allocate",  # Need for bootstrap to say 'use this method of security'
#         # "SDN.Allocate",  # Need for bootstrap to create the virtual private network on which to operate.
#         # "Sys.Modify",  # WHY
#         # "Sys.PowerMgmt",  # WHY
#         # "Sys.Syslog",  # WHY
#         # "User.Modify",  # Need for bootstrap to create users.
#         # "SDN.Use",  # Need for accessing internal SDN net
#         # "VM.Allocate",  # Need for bootstrap
#         # "VM.Clone",  # WHY - Potentially need?
#         # "VM.Config.CDROM",  # WHY - Potentially for cloud init
#         # "VM.Config.CPU",  # Need for bootstrap to define VMs
#         # "VM.Config.Cloudinit",  # WHY - Potentially for cloud init
#         # "VM.Config.Disk",  # WHY - Attaching disks
#         # "VM.Config.HWType",  # WHY?
#         # "VM.Config.Memory",  # WHY - Set memory for VMs
#         # "VM.Config.Network",  # WHY - Network settings on VM.
#         # "VM.Config.Options",  # WHY - VM Option configuration
#         # "VM.Console",  # WHY?
#         # "VM.Migrate",  # WHY?
#         # "VM.Monitor",  # WHY
#         # "VM.PowerMgmt",  # WHY
#         # "Datastore.Allocate", # Data volume creation and manipulation.
#         # "Datastore.AllocateSpace", # Data volume creation and manipulation.
#         # "Datastore.AllocateTemplate", # Data volume creation and manipulation.
#     ],
#     cluster_maintenance_privileges,
#     cluster_node_maintenance,
#     )
# }