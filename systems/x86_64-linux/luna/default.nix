{ inputs, lib, ... }:

with lib;
{
  imports = [
    ./hardware.nix
    ./hardware-generated.nix
  ];

  plusultra.roles.workstation = enabled;

  system.stateVersion = "23.05";
}
