rec {
  keys = {
    carbon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZjHdiGT2JDe/3tdEt5hNsOw6bOo0DEfGTkD4+7/ASs geko@carbon";
    neon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINc2W3jYUt55YbVipae62HMpiWWZ+w1MW7PbQV2o2nhl root@neon";
    silicon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnuNZ0JfFZ4sHUgatHZ+hE0qA+U7XX6m7ztTfmIrIgQ nixos@nixos";
    githubActions = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAtVRXCKspH+2rOE3d8bgPbkViwLlzfezfs9FW0waUoK github_actions";
  };
  groups = {
    hosts = [
      keys.carbon
      keys.silicon
      keys.neon
    ];
  };
}
