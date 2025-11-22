{
  config,
  lib,
  pkgs,
  options,
  inputs,
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

    services.upower.enable = true;

    elementary = {
      services.udiskie.enable = true;
      home.extraOptions.wayland.windowManager.hyprland =
        mkAliasDefinitions options.elementary.desktop.hyprland.extraHomeManagerOptions;
    };

    home-manager = {
      sharedModules = [ inputs.caelestia-shell.homeManagerModules.default ];
      users.${config.elementary.user.name} = {
        wayland.windowManager.hyprland = {
          enable = true;
          extraConfig =
            let
              applyVibrance = ''
                exec-once = ${lib.getExe pkgs.hyprshade} on vibrance
              '';
            in
            builtins.readFile ./hyprland.conf + applyVibrance;
        };

        programs.caelestia = {
          enable = true;
          settings = {
            paths.wallpaperDir = "${inputs.self.packages.${pkgs.system}.wallpapers}/result/share/wallpapers";
          };
          cli.enable = true;
        };

        home.sessionVariables = {
          MOZ_ENABLE_WAYLAND = 1;
          WLR_NO_HARDWARE_CURSORS = 1;
          # FIXME: remove when https://github.com/nix-community/home-manager/issues/4486 is fixed
          NIXOS_OZONE_WL = 1;
        };
      };
    };
  };
}
