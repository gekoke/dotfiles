{ config, lib, pkgs, inputs, goo, ... }:
with lib;
let cfg = config.plusultra.desktop.addons.waybar;
in
{
  options.plusultra.desktop.addons.waybar = with types; {
    enable = mkEnableOption "Waybar bar";
    hyprlandSupport = mkEnableOption "Hyprland support in Waybar";
  };

  config = mkIf cfg.enable {
    fonts.fonts = with pkgs; [
      # Icons in default configs
      font-awesome
    ];

    plusultra.home.programs.waybar = {
      enable = true;
      package = if cfg.hyprlandSupport
                then inputs.hyprland.packages.${pkgs.system}.waybar-hyprland
                else pkgs.waybar;
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
            modules-left = [
              "wlr/workspaces"
            ];
            modules-center = [
              "hyprland/window"
            ];

            "wlr/workspaces" = {
              sort-by-number = true;
              persistent_workspaces = {
                "1" = "[]";
                "2" = "[]";
                "3" = "[]";
                "4" = "[]";
                "5" = "[]";
                "6" = "[]";
                "7" = "[]";
                "8" = "[]";
                "9" = "[]";
                "10" = "[]";
              };
              on-scroll-up = "hyprctl dispatch workspace +1";
              on-scroll-down = "hyprctl dispatch workspace -1";
              on-click = "activate";
            };
          };
        in
          recursiveUpdate hyprlandConfig commonConfig;
    };

    plusultra.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      exec-once = waybar
    '';
  };
}
