{
  den.aspects.kitty.provides.to-users.homeManager.programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      update_check_interval = 0;
      confirm_os_window_close = 0;
      scrollback_pager = "nvim -c 'autocmd VimEnter * normal G' -";
    };
  };
}
