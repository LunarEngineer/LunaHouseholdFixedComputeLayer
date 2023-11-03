# Contents

## `usergroups.tf`

This contains a recipe to deploy users and groups; the definition for each variable requires a list of mapping structures, but the user fields are explicitly identified while the group fields are only in the documentation.

This also deploys a provisioning group and user.

## `roles.tf`

This is bound to the [`role_definitions`](./role_definitions/) folder, which contains some simple and reusable recipes for roles.

## `machines.tf`

This is bound to the [`machine`](./machine/) folder, which contains recipes for VMs.
