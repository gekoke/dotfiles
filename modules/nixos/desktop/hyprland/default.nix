{ config, lib, pkgs, options, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.desktop.hyprland;
in
{
  options.elementary.desktop.hyprland = with types; {
    enable = mkEnableOption "Hyprland window manager";
    extraHomeManagerOptions = mkOpt attrs { } "Options to pass directly to the Hyprland home-manager module";
    extraConfig = mkOpt str "" "Extra Hyprland configuration";
  };

  # TODO: add OBS/screen recording support
  config =
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        libsForQt5.qt5.qtwayland
        libsForQt5.qt5ct
        libva
      ];

      programs.hyprland = {
        enable = true;
        enableNvidiaPatches = config.elementary.hardware.nvidia.enable;
      };

      xdg.portal = {
        enable = true;
        # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      elementary = {
        programs.nwg-displays = {
          enable = true;
          enableHyprlandIntegration = true;
        };
        services.udiskie = enabled;

        desktop = {
          hyprland.extraHomeManagerOptions = {
            enable = true;
            enableNvidiaPatches = config.elementary.hardware.nvidia.enable;
            extraConfig =
              let
                masterMonocleCommand = ''
                  $kw = master:no_gaps_when_only
                  binde = SUPER, M, exec, hyprctl keyword $kw $(($(hyprctl getoption $kw -j | ${pkgs.jq}/bin/jq '.int') ^ 1))
                '';
              in
              builtins.readFile ./hyprland.conf + masterMonocleCommand;
          };
          addons = {
            waybar = enabled // { hyprlandSupport = true; };
            rofi = enabled;
            dunst = enabled;
            wlogout = enabled;
            avizo = enabled;
            unclutter = enabled;
            swww = enabled;
            swaylock = enabled;
            clipboard = enabled;
            keyring = enabled;
            screenshot = enabled // { hyprlandSupport = true; };
            cursor = enabled;
          };
        };

        home.sessionVariables = {
          WLR_NO_HARDWARE_CURSORS = 1;
          # FIXME: remove when https://github.com/nix-community/home-manager/issues/4486 is fixed
          NIXOS_OZONE_WL = 1;
        };
        home.extraOptions.wayland.windowManager.hyprland = mkAliasDefinitions options.elementary.desktop.hyprland.extraHomeManagerOptions;
      };
    };
}
