{pkgs, ...}: let
  wallpaper = ./wallpapers/spacejelly.jpg;
in {
  programs.feh.enable = true;

  xsession.initExtra = ''
    ${pkgs.feh}/bin/feh --bg-scale ${wallpaper}
  '';
}
