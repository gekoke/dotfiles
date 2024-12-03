let
  keys = {
    carbon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZjHdiGT2JDe/3tdEt5hNsOw6bOo0DEfGTkD4+7/ASs geko@carbon";
    silicon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnuNZ0JfFZ4sHUgatHZ+hE0qA+U7XX6m7ztTfmIrIgQ nixos@nixos";
  };
  all = builtins.attrValues keys;
in
{
  "authinfo.age".publicKeys = all;
}
