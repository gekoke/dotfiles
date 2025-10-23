let
  workstations = {
    carbon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZjHdiGT2JDe/3tdEt5hNsOw6bOo0DEfGTkD4+7/ASs geko@carbon";
    silicon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnuNZ0JfFZ4sHUgatHZ+hE0qA+U7XX6m7ztTfmIrIgQ nixos@nixos";
    hydrogen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNSy7ATWtt3KTv7UrEl3DAuL+iixSSF5xuGnJBAkaoG geko@hydrogen";
  };
  vms = {
    neon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2YlDRnXSrMX69w4QR0bKJwiDtQpaur3pJAOtEwizHY root@neon";
  };
  rest = {
    githubActions = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAtVRXCKspH+2rOE3d8bgPbkViwLlzfezfs9FW0waUoK github_actions";
  };

  hosts = workstations // vms;
  all = workstations // vms // rest;

  inherit (builtins) attrValues;
in
{
  for = all;
  ofAll = {
    workstations = attrValues workstations;
    hosts = attrValues hosts;
  };
}
