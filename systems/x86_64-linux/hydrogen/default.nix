{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.elementary) enabled;
in
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "25.11";

  programs = {
    nh.flake = "/home/geko/Repos/dotfiles";
    nix-ld.enable = true;
  };

  wsl = {
    enable = true;
    defaultUser = "geko";
    wslConf = {
      user.default = "geko";
      network.hostname = "hydrogen";
    };
  };

  home-manager.users.geko = {
    elementary = {
      accounts.geko.enable = true;
      cli-tools.enable = true;
      programs = {
        git.enable = true;
        gpg.enable = true;
      };
    };

    home = {
      packages = [
        pkgs.powershell
      ];

      shellAliases = {
        "cb" = "clip.exe";
        "cbo" = "powershell.exe Get-ClipBoard";
      };
    };

    services.gpg-agent.pinentry.package = pkgs.pinentry;
  };

  time.timeZone = "Europe/Tallinn";

  elementary = {
    virtualisation.docker.enable = true;
    nix = enabled;
    home = enabled;
    user = enabled;
    secrets = enabled;
    security = {
      sudo = enabled;
    };
    programs = {
      ssh = enabled;
      emacs = enabled;
      direnv = enabled;
    };
  };
}
