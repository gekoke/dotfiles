{ config, lib, ... }:
with lib;
with lib.elementary;
let
  cfg = config.elementary.programs.kitty;
in
{
  options.elementary.programs.kitty = {
    enable = mkEnableOption "Kitty terminal emulator";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
        update_check_interval = 0;
        confirm_os_window_close = 0;
        scrollback_pager = "nvim -c 'autocmd VimEnter * normal G' -";
      };
    };
  };
}
