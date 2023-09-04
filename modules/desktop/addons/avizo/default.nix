{ config, lib, ... }:

with lib;
let cfg = config.elementary.desktop.addons.avizo;
in
{
  options.elementary.desktop.addons.avizo = {
    enable = mkEnableOption "Avizo";
  };

  config = mkIf cfg.enable {
    elementary.home.services.avizo = enabled;

    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      bindle = ,XF86AudioRaiseVolume, exec, volumectl -u up
      bindle = ,XF86AudioLowerVolume, exec, volumectl -u down
      bindle = ,XF86AudioMute, exec,  volumectl toggle-mute
      bindle = ,XF86AudioMicMute, exec, volumectl -m toggle-mute

      bindle = ,XF86MonBrightnessUp, exec, lightctl up
      bindle = ,XF86MonBrightnessDown, exec, lightctl down
    '';
  };
}
