{ inputs, pkgs, ... }:
{
  imports =
    builtins.attrValues {
      inherit (inputs.nixos-hardware.nixosModules)
        common-pc
        common-pc-ssd
        common-cpu-intel
        common-gpu-nvidia-nonprime
        ;
    }
    ++ [ ./hardware-configuration.nix ];

  elementary = {
    preferences = {
      allowLongCompilationTimes = true;
    };

    virtualisation.docker.enable = true;
    hardware.nvidia.enable = true;
    roles.workstation.enable = true;
    secrets.enable = true;
  };

  home-manager.users.geko = {
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
