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
