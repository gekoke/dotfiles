{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.elementary.desktop.addons.waybar;
in
{
  options.elementary.desktop.addons.waybar = with types; {
    enable = mkEnableOption "Waybar bar";
    hyprlandSupport = mkEnableOption "Hyprland support in Waybar";
    style = mkOpt (nullOr (either path lines)) null "Waybar CSS style";
  };

  config = mkIf cfg.enable {
    # TODO: add MPD support
    elementary.home.programs.waybar = {
      enable = true;
      style = mkAliasDefinitions options.elementary.desktop.addons.waybar.style;
      package = pkgs.waybar.override { hyprlandSupport = cfg.hyprlandSupport; };
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
              "hyprland/workspaces"
            ];
            modules-center = [
              "hyprland/window"
            ];
            "hyprland/workspaces" = {
              "format" = "{name}";
              "persistent_workspaces"."*" = 10;
            };
          };
        in
        recursiveUpdate hyprlandConfig commonConfig;
    };

    elementary.home.extraOptions.systemd.user.services.waybar = {
      Unit = {
        Description = "Waybar bar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${config.elementary.home.programs.waybar.package}/bin/waybar";
        ExecReload = "${pkgs.coreutils}/bin/pkill -SIGUSR2 waybar";
        Restart = "always";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    # FIXME: when https://github.com/nix-community/home-manager/issues/2064 is resolved
    elementary.home.extraOptions.systemd.user.targets.tray = {
      Unit = {
        Description = "Fake tray service to appease incorrectly written systemd services";
        Requires = [ "graphical-session-pre.target" ];
        Restart = "always";
      };
    };
  };
}
