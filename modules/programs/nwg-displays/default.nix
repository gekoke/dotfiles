{ config, lib, pkgs, ... }:

with lib;
let cfg = config.elementary.programs.nwg-displays;
in
{
  options.elementary.programs.nwg-displays = {
    enable = mkEnableOption "nwg-displays";
    enableHyprlandIntegration = mkEnableOption "integration with Hyprland";
  };

  config = mkIf cfg.enable {
    elementary.home.packages = [
      (pkgs.nwg-displays.override { hyprlandSupport = cfg.enableHyprlandIntegration; })
    ];

    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = mkIf cfg.enableHyprlandIntegration ''
      source = ~/.config/hypr/monitors.conf
    '';
  };
}
