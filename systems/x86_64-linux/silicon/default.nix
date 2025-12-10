{
  inputs,
  pkgs,
  lib,
  self,
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

  programs = {
    nh.flake = "/home/geko/Repos/dotfiles";
    nix-ld.enable = true;
  };

  wsl = {
    enable = true;
    defaultUser = "geko";
    wslConf.user.default = "geko";
  };

  home-manager = {
    sharedModules = [ self.homeModules."programs.zsh" ];

    users.geko = {
      elementary = {
        accounts.geko.enable = true;
        cli-tools.enable = true;
        programs = {
          git.enable = true;
          gpg.enable = true;
        };
      };

      programs.zsh = {
        enable = true;
        elementary.config.enable = true;
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

      services.gpg-agent.pinentry.package = pkgs.pinentry;

      programs.git.userEmail = lib.mkForce "gregor.grigorjan@gamesglobal.com";
    };
  };

  networking.firewall.allowedTCPPorts = [
    1499 # For MSSQL containers -> Windows
  ];

  time.timeZone = "Europe/Tallinn";

  virtualisation.docker.enable = true;

  elementary = {
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
