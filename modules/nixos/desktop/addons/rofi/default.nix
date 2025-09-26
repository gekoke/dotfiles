{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;
with lib.elementary;
let
  cfg = config.elementary.desktop.addons.rofi;
in
{
  options.elementary.desktop.addons.rofi = with types; {
    enable = mkEnableOption "rofi launcher";
    rofi-collection.launcher = {
      enable = mkEnableOption "launcher theming from rofi-collection";
      type = mkOpt (ints.between 1 7) 1 "The type of theme to use from rofi-collection";
      style = mkOpt (ints.between 1 15) 1 "The style to use for the given rofi-collection type";
    };
  };

  config = mkIf cfg.enable {
    elementary.home.programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      extraConfig.show-icons = true;
      theme = mkIf cfg.rofi-collection.launcher.enable "${inputs.rofi-collection}/files/launchers/type-${toString cfg.rofi-collection.launcher.type}/style-${toString cfg.rofi-collection.launcher.style}.rasi";
    };

    elementary.home.configFile."rofi/colors" = mkIf cfg.rofi-collection.launcher.enable {
      source = "${inputs.rofi-collection}/files/colors";
      recursive = true;
    };

    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      bind = SUPER, P, exec, pkill rofi || rofi -show drun
    '';
  };
}
