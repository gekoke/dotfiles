provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "geko-carbon" {
  name       = "geko-carbon"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZjHdiGT2JDe/3tdEt5hNsOw6bOo0DEfGTkD4+7/ASs geko@carbon"
}

resource "hcloud_server" "neon" {
  name        = "neon"
  server_type = "cx22"
  image       = "debian-11"
  location    = "hel1" # Helsinki
  ssh_keys    = ["geko-carbon"]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}

module "neon_deploy" {
  source                 = "github.com/nix-community/nixos-anywhere//terraform/all-in-one?ref=ee813cc0e7c159c23fa536105247fc339d29cf82"
  nixos_system_attr      = ".#nixosConfigurations.neon.config.system.build.toplevel"
  nixos_partitioner_attr = ".#nixosConfigurations.neon.config.system.build.diskoScript"
  target_host            = hcloud_server.neon.ipv4_address
  instance_id            = hcloud_server.neon.id
}
