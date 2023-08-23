{ config, lib, pkgs, inputs, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.rofi;
in
{
  options.plusultra.desktop.addons.rofi = with types; {
    enable = mkEnableOption "rofi launcher";
    rofi-collection.launcher = {
      enable = mkEnableOption "launcher theming from rofi-collection";
      type = mkOpt (ints.between 1 7) 1 "The type of theme to use from rofi-collection";
      style = mkOpt (ints.between 1 15) 1 "The style to use for the given rofi-collection type";
    };
  };

  config = mkIf cfg.enable {
    # TODO: integrate rofi-collection with stylix colors and fonts
    plusultra.home.programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig.show-icons = true;
      theme = mkIf cfg.rofi-collection.launcher.enable
        "${inputs.rofi-collection}/files/launchers/type-${toString cfg.rofi-collection.launcher.type}/style-${toString cfg.rofi-collection.launcher.style}.rasi";
    };

    plusultra.home.configFile."rofi/colors" = mkIf cfg.rofi-collection.launcher.enable {
      source = "${inputs.rofi-collection}/files/colors";
      recursive = true;
    };

    # TODO: make alt-tab bind for hyprland
    plusultra.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      bind = SUPER, P, exec, pkill rofi || rofi -show drun
      bind = SUPER SHIFT, P, exec, rofi -show window -kb-cancel "Alt+Escape,Escape" -kb-accept-entry "!Alt-Tab,!Alt+Alt_L,Return" -kb-row-down "Alt+Tab,Down" -kb-row-up "Alt+ISO_Left_Tab,Up" -selected-row 1
    '';
  };
}
