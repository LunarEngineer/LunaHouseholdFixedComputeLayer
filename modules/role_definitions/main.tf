####################################################################
#                     Default Role Definitions                     #
# ---------------------------------------------------------------- #
# This module deploys some pre-baked recipes, collected and        #
#   organized relatively nicely.                                   #
####################################################################

output "default_roles" {
    description = "Default roles to build in the compute layer."
    sensitive   = false
    value       = [
        # Monitoring role.
        {"role_id": "fixed-compute-monitoring", "privileges": var.cluster_monitoring_privileges},
        # Maintenance roles
        {"role_id": "fixed-compute-maintenance-security", "privileges": var.cluster_monitoring_privileges},
        {"role_id": "fixed-compute-maintenance-node", "privileges": var.cluster_node_maintenance},
        {"role_id": "fixed-compute-maintenance-network", "privileges": var.cluster_network_maintenance},
        {"role_id": "fixed-compute-maintenance-cluster", "privileges": var.cluster_maintenance_privileges},
        # Bootstrap privileges
        {"role_id": "fixed-compute-provisioner", "privileges": var.bootstrap_privileges},
        
    ]
}