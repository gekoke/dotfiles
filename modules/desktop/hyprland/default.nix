{ config, lib, pkgs, inputs, options, ... }:

with lib;
let cfg = config.elementary.desktop.hyprland;
in
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

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
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
            recommendedEnvironment = true;
            enableNvidiaPatches = config.elementary.hardware.nvidia.enable;
            extraConfig =
              let
                masterMonocleCommand = ''
                  $kw = master:no_gaps_when_only
                  binde = SUPER, M, exec, hyprctl keyword $kw $(($(hyprctl getoption $kw -j | ${pkgs.jq}/bin/jq '.int') ^ 1))
                '';
                nvidiaEnvVars = optionalString config.elementary.hardware.nvidia.enable ''
                  env = LIBVA_DRIVER_NAME,nvidia
                  env = XDG_SESSION_TYPE,wayland
                  env = GBM_BACKEND,nvidia-drm
                  env = __GLX_VENDOR_LIBRARY_NAME,nvidia
                '';
              in
              builtins.readFile ./hyprland.conf + masterMonocleCommand + nvidiaEnvVars;
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
          wayland.windowManager.hyprland = mkAliasDefinitions options.elementary.desktop.hyprland.extraHomeManagerOptions;
        };
      };
    };
}
