{ config, lib, pkgs, inputs, options, ... }:

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

  config =
    mkIf cfg.enable {
      programs.hyprland = {
        enable = true;
        enableNvidiaPatches = config.elementary.hardware.nvidia.enable;
        # Only using Hyprland flake package for new features
        # (see https://github.com/hyprwm/Hyprland/issues/1947#issuecomment-1778605392)
        # FIXME: can be removed after nixpkgs bumps version to v0.31
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };

      xdg.portal = {
        enable = true;

        # See https://github.com/NixOS/nixpkgs/issues/239886
        # Enable xdg-desktop-portal-gtk unless we already have it from Gnome DE
        extraPortals = lib.optionals (!config.services.xserver.desktopManager.gnome.enable) [ pkgs.xdg-desktop-portal-gtk ];
      };

      elementary = {
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
