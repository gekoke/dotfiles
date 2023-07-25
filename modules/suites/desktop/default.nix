{ config, lib, ... }:

with lib;
let
  cfg = config.plusultra.suites.desktop;
in
{
  options.plusultra.suites.desktop = with types; {
    enable = mkEnableOption "common desktop configuration";
  };

  config = mkIf cfg.enable {
    plusultra = {
      desktop.hyprland = enabled;

      programs.alacritty = enabled;

      hardware = {
        storage = enabled;
        networking = enabled;
        audio = enabled;
      };

      system.keyboard = enabled;
    };
  };
}
