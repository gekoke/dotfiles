{
  config,
  lib,
  pkgs,
  options,
  ...
}:

with lib;
with lib.elementary;
let
  cfg = config.elementary.desktop.hyprland;
in
{
  options.elementary.desktop.hyprland = with types; {
    enable = mkEnableOption "Hyprland window manager";
    extraHomeManagerOptions =
      mkOpt attrs { }
        "Options to pass directly to the Hyprland home-manager module";
    extraConfig = mkOpt str "" "Extra Hyprland configuration";
  };

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;

    # Fixes bugs I guess? https://github.com/NixOS/nixpkgs/issues/160923
    xdg.portal.xdgOpenUsePortal = true;

    elementary = {
      services.udiskie = enabled;

      desktop = {
        hyprland.extraHomeManagerOptions = {
          enable = true;
          package = null;
          portalPackage = null;
          extraConfig =
            let
              applyVibrance = ''
                exec-once = ${lib.getExe pkgs.hyprshade} on vibrance
              '';
            in
            builtins.readFile ./hyprland.conf + applyVibrance;
        };
        addons = {
          waybar = enabled // {
            hyprlandSupport = true;
          };
          rofi = enabled;
          dunst = enabled;
          wlogout = enabled;
          avizo = enabled;
          unclutter = enabled;
          swaylock = enabled;
          clipboard = enabled;
          keyring = enabled;
          screenshot = enabled // {
            hyprlandSupport = true;
          };
          cursor = enabled;
        };
      };

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        WLR_NO_HARDWARE_CURSORS = 1;
        # FIXME: remove when https://github.com/nix-community/home-manager/issues/4486 is fixed
        NIXOS_OZONE_WL = 1;
      };
      home.extraOptions.wayland.windowManager.hyprland =
        mkAliasDefinitions options.elementary.desktop.hyprland.extraHomeManagerOptions;
    };
  };
}
