{ config, lib, ... }:

with lib;
with lib.elementary;
let
  cfg = config.elementary.desktop.addons.unclutter;
in
{
  options.elementary.desktop.addons.unclutter = with types; {
    enable = mkEnableOption "hiding mouse after an idle period";
    timeoutInSeconds = mkOpt ints.positive 5 "idle period (in seconds) to hide mouse after";
  };

  config = mkIf cfg.enable {
    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      cursor {
        inactive_timeout = ${toString cfg.timeoutInSeconds}
      }
    '';
  };
}
