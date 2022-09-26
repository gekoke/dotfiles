{pkgs, ...}:
{
  services.xserver.enable = true;
  xdg.dataFile.".background-image" = ./wallpapers/spacejelly.jpg;
}
