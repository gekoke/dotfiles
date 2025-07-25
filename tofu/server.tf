provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "geko_carbon" {
  name       = "geko_carbon"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZjHdiGT2JDe/3tdEt5hNsOw6bOo0DEfGTkD4+7/ASs geko@carbon"
}

resource "hcloud_ssh_key" "github_actions" {
  name       = "github_actions"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAtVRXCKspH+2rOE3d8bgPbkViwLlzfezfs9FW0waUoK github_actions"
}

resource "hcloud_server" "neon" {
  name        = "neon"
  server_type = "cx22"
  image       = "debian-11"
  location    = "hel1" # Helsinki
  ssh_keys    = ["geko_carbon", "github_actions", ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

module "neon_deploy" {
  source                 = "github.com/nix-community/nixos-anywhere//terraform/all-in-one?ref=37cd5408a443cbba2e377d634e8b161b9a7af64f"
  nixos_system_attr      = ".#nixosConfigurations.neon.config.system.build.toplevel"
  nixos_partitioner_attr = ".#nixosConfigurations.neon.config.system.build.diskoScript"
  target_host            = hcloud_server.neon.ipv4_address
  instance_id            = hcloud_server.neon.id
}
