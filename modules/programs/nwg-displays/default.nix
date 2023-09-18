{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.elementary.programs.nwg-displays;
  package = (import inputs.nwg-displays-with-desktop-file { inherit (pkgs) system; }).pkgs.nwg-displays;
in
{
  options.elementary.programs.nwg-displays = {
    enable = mkEnableOption "nwg-displays";
    enableHyprlandIntegration = mkEnableOption "integration with Hyprland";
  };

  config = mkIf cfg.enable {
    elementary.home.packages = [
      (package.override { hyprlandSupport = cfg.enableHyprlandIntegration; })
    ];

    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = mkIf cfg.enableHyprlandIntegration ''
      source = ~/.config/hypr/monitors.conf
    '';
  };
}
