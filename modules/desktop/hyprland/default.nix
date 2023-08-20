{ config, lib, pkgs, inputs, options, ... }:

with lib;
let cfg = config.plusultra.desktop.hyprland;
in
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  options.plusultra.desktop.hyprland = with types; {
    enable = mkEnableOption "Hyprland window manager";
    extraHomeManagerOptions = mkOpt attrs { } "Options to pass directly to the Hyprland home-manager module";
    extraConfig = mkOpt str "" "Extra Hyprland configuration";
  };

  # TODO: add OBS/screen recording support
  config =
    mkIf cfg.enable {
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

      programs.hyprland = {
        enable = true;
        enableNvidiaPatches = config.plusultra.hardware.nvidia.enable;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      plusultra = {
        desktop = {
          hyprland.extraHomeManagerOptions = {
            enable = true;
            enableNvidiaPatches = config.plusultra.hardware.nvidia.enable;
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

        home.sessionVariables.WLR_NO_HARDWARE_CURSORS = 1;
        home.extraOptions = {
          imports = [ inputs.hyprland.homeManagerModules.default ];
          wayland.windowManager.hyprland = mkAliasDefinitions options.plusultra.desktop.hyprland.extraHomeManagerOptions;
        };
      };
    };
}
