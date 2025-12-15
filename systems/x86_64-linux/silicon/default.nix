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
    self.nixosModules."roles.wsl"
  ];

  system.stateVersion = "24.11";

  roles.wsl = {
    enable = true;
    defaultUser = "geko";
  };

  programs = {
    nh.flake = "/home/geko/Repos/dotfiles";
    nix-ld.enable = true;
  };

  home-manager = {
    sharedModules = [
      self.homeModules."programs.git"
      self.homeModules."programs.zsh"
    ];

    users.geko = {
      elementary = {
        accounts.geko.enable = true;
        cli-tools.enable = true;
        programs = {
          gpg.enable = true;
        };
      };

      programs.git = {
        enable = true;
        elementary.config.enable = true;
        includes = [
          {
            condition = "gitdir:~/Work/";
            contents.user.email = "gregor.grigorjan@gamesglobal.com";
          }
        ];
      };

      programs.zsh = {
        enable = true;
        elementary.config.enable = true;
      };

      home = {
        file."Work/.hmkeep".text = "";

        packages = [
          # keep-sorted start block=yes
          pkgs.azure-cli
          pkgs.bun
          pkgs.powershell
          # keep-sorted end
        ];
      };
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
    programs = {
      ssh = enabled;
      emacs = enabled;
      direnv = enabled;
    };
  };
}
