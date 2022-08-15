{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./wm
    ./compositor
    ./wallpaper
    ./bar
  ];

  xsession.enable = true;

  programs = {
    fish.shellAliases = {
      cb = "xclip -sel clip";
      cbo = "xclip -o -sel clip";
    };
    zsh.shellAliases = {
      cb = "xclip -sel clip";
      cbo = "xclip -o -sel clip";
    };
  };
}
