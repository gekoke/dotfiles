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

  system.stateVersion = "24.11";

  programs.nh.flake = "/home/geko/Repos/dotfiles";

  wsl = {
    enable = true;
    defaultUser = "geko";
    wslConf = {
      user.default = "geko";
      network.hostname = "silicon";
    };
  };

  home-manager.users.geko = {
    elementary = {
      accounts.geko.enable = true;
      cli-tools.enable = true;
      programs.git.enable = true;
    };

    home = {
      packages = [
        pkgs.azure-cli
        pkgs.bun
        pkgs.powershell
      ];

      shellAliases = {
        "cb" = "clip.exe";
        "cbo" = "powershell.exe Get-ClipBoard";
      };
    };

    programs.git.userEmail = lib.mkForce "gregor.grigorjan@gamesglobal.com";
  };

  networking.firewall.allowedTCPPorts = [
    1499 # For MSSQL containers -> Windows
  ];

  time.timeZone = "Europe/Tallinn";

  elementary = {
    virtualisation.docker.enable = true;
    nix = enabled;
    home = enabled;
    user = enabled;
    secrets = enabled;
    security = {
      sudo = enabled;
      gpg = enabled // {
        pinentryPackage = pkgs.pinentry;
      };
    };
    programs = {
      ssh = enabled;
      emacs = enabled;
      direnv = enabled;
    };
  };
}
