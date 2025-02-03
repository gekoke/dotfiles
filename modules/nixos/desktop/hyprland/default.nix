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
    programs.hyprland = {
      enable = true;
    };

    xdg.portal = {
      enable = true;

      # xdg-desktop-portal 1.17 reworked how portal implementations are loaded, you
      # should either set `xdg.portal.config` or `xdg.portal.configPackages`
      # to specify which portal backend to use for the requested interface.

      # https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in

      # If you simply want to keep the behaviour in < 1.17, which uses the first
      # portal implementation found in lexicographical order, use the following:

      # xdg.portal.config.common.default = "*";
      config.common.default = "*";

      # See https://github.com/NixOS/nixpkgs/issues/239886
      # Enable xdg-desktop-portal-gtk unless we already have it from Gnome DE
      extraPortals = lib.optionals (!config.services.xserver.desktopManager.gnome.enable) [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    elementary = {
      services.udiskie = enabled;

      desktop = {
        hyprland.extraHomeManagerOptions = {
          enable = true;
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
        WLR_NO_HARDWARE_CURSORS = 1;
        # FIXME: remove when https://github.com/nix-community/home-manager/issues/4486 is fixed
        NIXOS_OZONE_WL = 1;
      };
      home.extraOptions.wayland.windowManager.hyprland =
        mkAliasDefinitions options.elementary.desktop.hyprland.extraHomeManagerOptions;
    };
  };
}
