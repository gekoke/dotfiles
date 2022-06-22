{ pkgs, ... }:
{
  xdg.configFile."rofi/launchers".source = ./config/launchers;
  home.packages = with pkgs; [ rofi ];
}

