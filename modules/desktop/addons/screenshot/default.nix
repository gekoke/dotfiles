{ config, lib, pkgs, inputs, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.screenshot;
in
{
  options.plusultra.desktop.addons.screenshot = {
    enable = mkEnableOption "screenshots";
    hyprlandSupport = mkEnableOption "Hyprland screenshot support";
  };

  config = mkIf cfg.enable {
    plusultra.home.packages = [(
      if cfg.hyprlandSupport
      then inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      else abort "only supports Hyprland - set 'hyprlandSupport' module option to true"
    )];
  };
}
