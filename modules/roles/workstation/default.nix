{ config, lib, ... }:

with lib;
let cfg = config.plusultra.roles.workstation;
in
{
  options.plusultra.roles.workstation = with types; {
    enable = mkEnableOption "the workstation role";
  };

  config = mkIf cfg.enable {
    plusultra = {
      nix = enabled;
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
      };
      system.boot = enabled;
    };
  };
}
