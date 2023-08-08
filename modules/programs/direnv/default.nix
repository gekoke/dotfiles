{ config, lib, ... }:

with lib;
let cfg = config.plusultra.programs.direnv;
in
{
  options.plusultra.programs.direnv = with types; {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    plusultra.home.sessionVariables."DIRENV_LOG_FORMAT" = "";
    plusultra.home.programs.direnv = {
      enable = true;
      nix-direnv = enabled;
    };
  };
}
