# LunaHouseholdFixedComputeLayer

This is the lowest layer of the LunaHousehold Server.

This exposes a module which takes a list of k8s nodes and deploys a recipe into each.

This uses the environment variables `PM_API_URL`, `PM_API_TOKEN_SECRET`, and `PM_API_TOKEN_ID` (or other appropriate credentials) to define connectivity for the provider.
