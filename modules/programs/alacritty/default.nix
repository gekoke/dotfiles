{ config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.programs.alacritty;
in
{
  options.plusultra.programs.alacritty = {
    enable = mkEnableOption "Alacritty terminal emulator";
  };

  config = mkIf cfg.enable {
    plusultra.home.programs.alacritty.enable = true;
    plusultra.home.programs.alacritty.settings = {
      window = {
        padding = {
          x = 4;
          y = 4;
        };
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "Always";
        };
        vi_mode_style = {
          shape = "Block";
          blinking = "Never";
        };
        blink_interval = 750;
      };
    };

    plusultra.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      binde = SUPER, apostrophe, exec, alacritty
    '';
  };
}
