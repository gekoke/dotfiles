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
      package =
        # FIXME: remove when waybar hits v0.9.23
        # Currently using a newer git revision for better persistent workspaces support
        (pkgs.waybar.override { inherit (cfg) hyprlandSupport; }).overrideAttrs (_: {
          version = "v0.9.22-git-a90e27";
          src = pkgs.fetchFromGitHub {
            owner = "Alexays";
            repo = "Waybar";
            rev = "a90e275d5e26226c9e69abbb6f9be4d7391ba3c1";
            hash = "sha256-AKjdQH+jey1A235xQXVtogeqLUaB/SBfraGJw/tvwz8=";
          };
        });
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
