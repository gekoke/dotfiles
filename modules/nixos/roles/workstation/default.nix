{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.elementary;
let
  cfg = config.elementary.roles.workstation;
in
{
  options.elementary.roles.workstation = with types; {
    enable = mkEnableOption "the workstation role";
  };

  config = mkIf cfg.enable {
    home-manager.users.geko = {
      elementary = {
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
      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
      home.packages = [
        # pinentry-gnome3
        pkgs.gcr
      ];
    };

    elementary = {
      nix = enabled;
      home = enabled;
      user = enabled;
      suites = {
        desktop = enabled;
      };
      security = {
        sudo = enabled;
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
