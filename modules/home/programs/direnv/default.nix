{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.programs.direnv.elementary.config;
in
{
  options.programs.direnv.elementary.config = {
    enable = mkEnableOption "Elementary direnv configuration";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true; 
    };
  };
}
