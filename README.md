# LunaHouseholdFixedComputeLayer

This is the lowest layer of the LunaHousehold Server.

This exposes a module which deploys a k8s node to a proxmox node.

This uses the environment variables `PM_API_URL`, `PM_API_TOKEN_SECRET`, and `PM_API_TOKEN_ID` (or other appropriate credentials) to define connectivity for the provider.

Contents:

* Resource("proxmox_vm_qemu"-"k8s_node"): This deploys a k8s node to a proxmox qemu vm.
* Variable("proxmox_node_config"): This describes the input data structure to the resource.

Roadmap: Parameterization by start / join cluster and control / worker.