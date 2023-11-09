# This creates *IF IT DOES NOT EXIST* a file on the cluster.
# This file is the downloaded ISO

# variable "vm-config-gaming" {
#     default = {
#         "machine_type": "gaming-vm",
#         # Note, to generate one of these darn things head on out to https://www.microsoft.com/software-download/windows11
#         "machine_template": "https://software.download.prss.microsoft.com/dbazure/Win11_23H2_English_x64.iso?t=ba979a8d-c51d-4771-b7d9-636cda6dabab&e=1699011452&h=4d886068f2f9d1cfc5f63b17fe5c730d65256112afb3114fd757ec8db1d8902a"
#     }
# }

resource "proxmox_virtual_environment_file" "vm_iso" {
  #  A VZ template is a tar.gz archive, which is “installed” into the private area of a container.
  #  It contains the necessary file system structure with all the files required to boot the system,
  #  set up networking, and start a set of services.
  content_type = "vztmpl"
  datastore_id = vars.datastore
  node_name    = vars.node

  source_file {
    path = "https://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
  }
}