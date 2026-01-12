# Provisioning New VPSs

## Blue-Green (replace VPS in-place)

- `pgdump` the DB state (see [`./neon/README.md`](./neon/README.md))
- provision a new server in `tofu/server.tf` with resource name `SERVER2`
- get public IP: `tofu state show hcloud_server.SERVER2`
- `ssh-keyscan PUBLIC_IP` for the public key
- rekey the secrets (see [`../../secrets/README.md`](../../secrets/README.md)) (replace old server's key with new key)
- add a new `nixosConfiguration` and deploy
- load the DB state (see [`./neon/README.md`](./neon/README.md))
- destroy old server
