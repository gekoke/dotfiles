{ config, lib, pkgs, inputs, ... }:
with lib;
let cfg = config.plusultra.desktop.addons.waybar;
in
{
  options.plusultra.desktop.addons.waybar = with types; {
    enable = mkEnableOption "Waybar bar";
    hyprlandSupport = mkEnableOption "Hyprland support in Waybar";
  };

  config = mkIf cfg.enable {
    # TODO: add MPD support
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

    plusultra.home.extraOptions.systemd.user.services.waybar = {
      Unit = {
        Description = "Waybar bar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${config.plusultra.home.programs.waybar.package}/bin/waybar";
        ExecReload = "${pkgs.coreutils}/bin/pkill -SIGUSR2 waybar";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    # FIXME: when https://github.com/nix-community/home-manager/issues/2064 is resolved
    plusultra.home.extraOptions.systemd.user.targets.tray = {
      Unit = {
        Description = "Fake tray service to appease incorrectly written systemd services";
        Requires = [ "graphical-session-pre.target" ];
        Restart = "always";
      };
    };
  };
}
