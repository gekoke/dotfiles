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

  home.packages = with pkgs; [xclip];
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
