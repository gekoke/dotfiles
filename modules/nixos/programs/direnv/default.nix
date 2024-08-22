{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.elementary.programs.direnv;
in
{
  options.elementary.programs.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      config = {
        global = {
          hide_env_diff = true; 
        };
      };
    };
  };
}
