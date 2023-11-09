

module "fixed_compute_layer_modules" {
  source              = "./modules"
  # Inputs for the usergroups.tf
  users               = var.users
  groups              = var.groups
  # Inputs for the roles
  roles               = var.roles
  # Inputs for the machines
  # machines_to_create  = var.machines
}
