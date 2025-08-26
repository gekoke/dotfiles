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
    home = {
      packages = [
        pkgs.azure-cli
        pkgs.bun
        pkgs.gcc
        pkgs.gnumake
        pkgs.nodePackages."@angular/cli"
        pkgs.powershell
        pkgs.python311
      ];

      shellAliases = {
        "cb" = "clip.exe";
        "cbo" = "powershell.exe Get-ClipBoard";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    1499 # For MSSQL containers -> Windows
  ];

  time.timeZone = "Europe/Tallinn";

  elementary = {
    virtualisation.docker.enable = true;
    nix = enabled;
    home = enabled;
    user = enabled // {
      accounts = enabled;
    };
    secrets = enabled;
    suites = {
      cli-utils = enabled;
    };
    security = {
      sudo = enabled;
      gpg = enabled // {
        pinentryPackage = pkgs.pinentry;
      };
    };
    programs = {
      git = enabled // {
        userEmail = "gregor.grigorjan@gamesglobal.com";
      };
      ssh = enabled;
      emacs = enabled;
      direnv = enabled;
    };
  };
}
