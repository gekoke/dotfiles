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
      suites = {
        common = enabled;
        desktop = enabled;
        cli-utils = enabled;
      };
      programs = {
        emacs = enabled; 
        firefox = enabled;
      };
    };
  };
}
