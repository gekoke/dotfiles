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
    virtualisation.docker.enable = true;
    hardware.nvidia.enable = true;
    roles.workstation.enable = true;
    secrets.enable = true;
    programs.git.signingKey = "1E9AFDF3275F99EE";
    programs.emacs.package = pkgs.emacs30-pgtk;
  };

  home-manager.users.geko = {
    home.packages = [
      pkgs.discord
      pkgs.qbittorrent
      pkgs.mpv
      pkgs.steam-run
    ];
  };

  boot.loader.grub.gfxmodeEfi = "1920x1080";

  networking.firewall.allowedTCPPorts = [
    8000
    8080
  ];

  system.stateVersion = "25.05";
}
