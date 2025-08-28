{ config, lib, ... }:

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
        programs.git.enable = true;
      };
    };

    elementary = {
      nix = enabled;
      home = enabled;
      user = enabled;
      suites = {
        desktop = enabled;
      };
      security = {
        gpg = enabled;
        sudo = enabled;
      };
      programs = {
        ssh = enabled;
        emacs = enabled;
        firefox = enabled;
        direnv = enabled;
        spotify = enabled;
      };
      system.boot = enabled;
    };
  };
}
