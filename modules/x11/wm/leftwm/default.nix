{ pkgs, ... }:
let
  theme = "spacejelly";
in
{
  imports =
    [
      ../../../programs/rofi
    ];

   xdg.configFile."leftwm/".source = ./config;
   xsession.initExtra = ''
     ${pkgs.leftwm}/bin/leftwm-command "LoadTheme ~/.config/leftwm/${theme}/theme.toml"
   '';
}
