{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.elementary;
let
  cfg = config.elementary.desktop.addons.waybar;
in
{
  options.elementary.desktop.addons.waybar = with types; {
    enable = mkEnableOption "Waybar bar";
    hyprlandSupport = mkEnableOption "Hyprland support in Waybar";
    style = mkOpt (nullOr (either path lines)) (lib.mkDefault null) "Waybar CSS style";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.waybar = {
      enable = true;
      style = mkAliasDefinitions options.elementary.desktop.addons.waybar.style;
      systemd.enable = true;
      settings.mainBar =
        let
          commonConfig = {
            position = "top";

            modules-right = [
              "mpd"
              "pulseaudio"
              "network"
              "backlight"
              "battery"
              "battery#bat2"
              "clock"
              "tray"
            ];
          };

          hyprlandConfig = {
            layer = "top";
            modules-left = [ "hyprland/workspaces" ];
            modules-center = [ "hyprland/window" ];
            "hyprland/workspaces" = {
              "format" = "{name}";
            };
          };
        in
        recursiveUpdate hyprlandConfig commonConfig;
    };
  };
}
