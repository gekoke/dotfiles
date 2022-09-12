{pkgs, ...}: let
  pythonDependencies = python-packages: with python-packages; [adblock];
in {
  home.packages = with pkgs; [
    qutebrowser
    (python38.withPackages pythonDependencies)
  ];
  xdg.configFile."qutebrowser/config.py".source = ./config.py;
}
