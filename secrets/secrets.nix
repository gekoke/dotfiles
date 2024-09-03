let
  keys = {
    carbon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFnuZ4/euSxfZvqLPkhGsfUqLCPl5MXMtfAE9xeAmhP gregor@grigorjan.net";
    silicon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnuNZ0JfFZ4sHUgatHZ+hE0qA+U7XX6m7ztTfmIrIgQ nixos@nixos";
  };
  all = builtins.attrValues keys;
in
{
  "authinfo.age".publicKeys = all;
  "atuin-key.age".publicKeys = all;
  "private-ssh-config.age".publicKeys = all;
}
