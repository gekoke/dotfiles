{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./wm
      ./compositor
      ./wallpaper
      ./bar
    ];

  xsession.enable = true;
}

