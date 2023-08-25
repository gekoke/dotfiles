{ config, lib, ... }:
with lib;
let cfg = config.plusultra.programs.alacritty;
in
{
  options.plusultra.programs.alacritty = {
    enable = mkEnableOption "Alacritty terminal emulator";
    enableHotkey = mkEnableOption "hotkey for Alacritty";
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

    plusultra.desktop.hyprland.extraHomeManagerOptions.extraConfig = mkIf cfg.enableHotkey ''
      binde = SUPER, apostrophe, exec, alacritty
    '';

    assertions = [
      {
        message = "enableHotkey can only be enabled for 0 or 1 terminal emulators";
        assertion = cfg.enableHotkey -> !config.plusultra.programs.kitty.enableHotkey;
      }
    ];
  };
}
