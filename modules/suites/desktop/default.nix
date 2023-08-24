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
    services.xserver = enabled // { displayManager.gdm = enabled; };

    plusultra = {
      desktop.hyprland = enabled;

      programs.alacritty = enabled;

      services.udiskie = enabled;

      hardware = {
        storage = enabled;
        networking = enabled;
        audio = enabled;
      };

      system.keyboard = enabled;
    };
  };
}
