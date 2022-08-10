{pkgs, ...}: {
  home.packages = with pkgs; [qutebrowser];
  xdg.configFile."qutebrowser/config.py".source = ./config.py;
}
