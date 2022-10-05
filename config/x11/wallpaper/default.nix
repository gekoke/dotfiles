{ pkgs, ... }:
{
  xsession.enable = true;
  home.file.".background-image".source = ./wallpapers/spacejelly.jpg;
}
