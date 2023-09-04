{ config, lib, pkgs, ... }:
with lib;
let cfg = config.elementary.programs.kitty;
in
{
  options.elementary.programs.kitty = {
    enable = mkEnableOption "Kitty terminal emulator";
    enableHotkey = mkEnableOption "hotkey for Kitty";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
        update_check_interval = 0;
        confirm_os_window_close = 0;
        scrollback_pager = "${getExe pkgs.neovim} -c 'setlocal relativenumber clipboard=unnamedplus' -c 'autocmd VimEnter * normal G' -";
      };
    };

    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = mkIf cfg.enableHotkey ''
      binde = SUPER, apostrophe, exec, kitty
    '';

    assertions = [
      {
        message = "enableHotkey can only be enabled for 0 or 1 terminal emulators";
        assertion = cfg.enableHotkey -> !config.elementary.programs.alacritty.enableHotkey;
      }
    ];
  };
}
