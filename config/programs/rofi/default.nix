{ lib, pkgs, config, ... }:
with lib;
with builtins;
let
  p = config.prefs.style.palette;
  theme = ./styles/style_2.rasi;
in {
  programs.rofi = {
    enable = true;
    theme = theme;
  };

  xdg.configFile."rofi/${baseNameOf theme}".source = theme;
  xdg.configFile."rofi/colors.rasi".text = ''
    * {
      al:  #00000000;    // Text background
      bg:  ${p.base0}ff; // Program list background
      se:  ${p.base1}ff; // Program list selection background
      fg:  ${p.lite1}ff; // Text color
      ac:  ${p.colo1}ff; // Top bar background
    }
  '';

  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + p" = "rofi -show drun -no-lazy-grab";
    };
  };
}
