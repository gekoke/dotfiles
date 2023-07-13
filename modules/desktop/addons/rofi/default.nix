{ config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.rofi;
in
{
  options.plusultra.desktop.addons.rofi = {
    enable = mkEnableOption "rofi launcher";
  };

  config = mkIf cfg.enable {
    plusultra = {
      home.packages = [ pkgs.rofi-wayland ];

      desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
        bind = SUPER, P, exec, pkill rofi || rofi -show drun
      '';
    };
  };
}
