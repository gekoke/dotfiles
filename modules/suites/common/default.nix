{ config, lib, ... }:

with lib;
let
  cfg = config.plusultra.suites.common;
in
{
  options.plusultra.suites.common = with types; {
    enable = mkEnableOption "common configuration";
  };

  config = mkIf cfg.enable {
    plusultra = {
      nix = enabled;
      programs = {
        git = enabled; 
        ssh = enabled;
      };
      security = {
        gpg = enabled;
        sudo = enabled;
      };
      system.boot = enabled;
    };
  };
}
