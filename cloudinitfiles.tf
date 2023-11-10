module "cloudinit_files" {
  source            = "git@github.com:lunarengineer-bot/lunar-engineering-cloud-init-kube.git"
  organization_name = variable.organization_name
  hosts             = data.proxmox_virtual_environment_nodes.available_nodes
  users             = [{
    username         = "tim",
    sudo             = true,
    ssh_public_key   = "Whatever"
  }]
  groups = [{
    groupname    = "gamers",
    groupmembers = ["tim"]
  }]
  packages = ["ntp", "qemu-guest-agent"]
}

output "cloudinit_files" {
  description = "Cloud init files generated for the hosts"
  sensitive = false
  value = module.cloudinit_files.output.cloudinitfile
}
