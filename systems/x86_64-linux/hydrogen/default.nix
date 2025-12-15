{
  lib,
  self,
  ...
}:
let
  inherit (lib.elementary) enabled;
in
{
  imports = [
    self.nixosModules."roles.wsl"
  ];

  system.stateVersion = "25.11";

  programs = {
    nh.flake = "/home/geko/Repos/dotfiles";
    nix-ld.enable = true;
  };

  roles.wsl = {
    enable = true;
    defaultUser = "geko";
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

      programs = {
        git = {
          enable = true;
          elementary.config.enable = true;
        };
        zsh = {
          enable = true;
          elementary.config.enable = true;
        };
      };
    };
  };

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
