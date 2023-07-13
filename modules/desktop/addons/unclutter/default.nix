{ config, lib, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.unclutter;
in
{
  options.plusultra.desktop.addons.unclutter = with types; {
    enable = mkEnableOption "hiding mouse after an idle period";
    timeoutInSeconds = mkOpt ints.positive 5 "idle period (in seconds) to hide mouse after";
  };

  config = mkIf cfg.enable {
    plusultra.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      general {
        cursor_inactive_timeout = ${toString cfg.timeoutInSeconds}
      }
    '';
  };
}
