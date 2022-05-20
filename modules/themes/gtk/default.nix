{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "SolArc-Dark";
      package = pkgs.solarc-gtk-theme;
    };
  };
}
