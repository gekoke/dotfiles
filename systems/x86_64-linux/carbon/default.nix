{ lib, inputs, ... }:

with lib;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    common-pc
    common-pc-ssd
    common-cpu-intel-kaby-lake
    common-gpu-nvidia-nonprime
  ];

  elementary = {
    hardware.nvidia = enabled;
    roles.workstation = enabled;
    secrets = enabled;
  };

  boot.loader.grub.gfxmodeEfi = "1920x1080";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8000
      8080
    ];
  };

  system.stateVersion = "23.11";
}
