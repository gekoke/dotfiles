{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  theme = ./styles/style_2.rasi;
  cfg = config.modules.programs.rofi;
in
{
  options.modules.programs.rofi = {
    enable = mkEnableOption "Rofi program launcher";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    programs.rofi = {
      enable = true;
      theme = theme;
    };

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];

    xdg.configFile."rofi/${baseNameOf theme}".source = theme;
    xdg.configFile."rofi/colors.rasi".text = ''
      * {
        al:  #00000000; // Text background
        bg:  #2E3440ff; // Program list background
        se:  #3B4252ff; // Program list selection background
        fg:  #E5E9F0ff; // Text color
        ac:  #88C0D0ff; // Top bar background
      }
    '';

    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + p" = "rofi -show drun -no-lazy-grab";
      };
    };
  };
}
