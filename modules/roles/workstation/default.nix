{ config, lib, ... }:

with lib;
let cfg = config.elementary.roles.workstation;
in
{
  options.elementary.roles.workstation = with types; {
    enable = mkEnableOption "the workstation role";
  };

  config = mkIf cfg.enable {
    elementary = {
      nix = enabled;
      user = enabled // { accounts = enabled; };
      suites = {
        desktop = enabled;
        cli-utils = enabled;
      };
      security = {
        gpg = enabled;
        sudo = enabled;
      };
      programs = {
        git = enabled;
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
