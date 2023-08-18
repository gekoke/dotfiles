{ lib, ... }:

with lib;
{
  imports = [
    ./hardware.nix
    ./hardware-generated.nix
  ];

  plusultra.roles.workstation = enabled;

  system.stateVersion = "23.05";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8000
      8080
    ];
  };
}
