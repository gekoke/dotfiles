{
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;
with lib.elementary;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    common-pc
    common-pc-ssd
    common-cpu-intel-kaby-lake
    common-gpu-nvidia-nonprime
  ];

  elementary = {
    preferences = {
      allowLongCompilationTimes = true;
    };

    virtualisation.docker = enabled;
    hardware.nvidia = enabled;
    roles.workstation = enabled;
    secrets = enabled;
    home.packages = [
      pkgs.discord
      pkgs.qbittorrent
      pkgs.mpv
    ];
  };

  boot.loader.grub.gfxmodeEfi = "1920x1080";

  networking.firewall.allowedTCPPorts = [
    8000
    8080
  ];

  system.stateVersion = "24.05";
}
