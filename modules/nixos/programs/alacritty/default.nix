{ config, lib, ... }:
with lib;
with lib.elementary;
let
  cfg = config.elementary.programs.alacritty;
in
{
  options.elementary.programs.alacritty = {
    enable = mkEnableOption "Alacritty terminal emulator";
    enableHotkey = mkEnableOption "hotkey for Alacritty";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.alacritty.enable = true;
    elementary.home.programs.alacritty.settings = {
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

    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = mkIf cfg.enableHotkey ''
      binde = SUPER, apostrophe, exec, alacritty
    '';

    assertions = [
      {
        message = "enableHotkey can only be enabled for 0 or 1 terminal emulators";
        assertion = cfg.enableHotkey -> !config.elementary.programs.kitty.enableHotkey;
      }
    ];
  };
}
