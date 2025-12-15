{
  config,
  lib,
  pkgs,
  self,
  ...
}:

with lib;
with lib.elementary;
let
  cfg = config.roles.workstation;
in
{
  options.roles.workstation = with types; {
    enable = mkEnableOption "the workstation role";
  };

  config = mkIf cfg.enable {
    security.sudo.wheelNeedsPassword = false;

    home-manager = {
      sharedModules = [
        self.homeModules."programs.git"
        self.homeModules."programs.zsh"
      ];
      users.geko = {
        elementary = {
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
        services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
        home.packages = [
          # pinentry-gnome3
          pkgs.gcr
        ];
      };
    };

    elementary = {
      nix = enabled;
      home = enabled;
      user = enabled;
      suites = {
        desktop = enabled;
      };
      programs = {
        ssh = enabled;
        emacs = enabled;
        firefox = enabled;
        direnv = enabled;
      };
      system.boot = enabled;
    };
  };
}
