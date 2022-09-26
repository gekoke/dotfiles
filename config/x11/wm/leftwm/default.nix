{pkgs, user, ...}: let
  theme = "spacejelly";
in {
  imports = [
    ../../../programs/rofi
  ];

  xdg.configFile."leftwm/".source = ./config;
  xsession.initExtra = ''
    leftwm-command "LoadTheme /home/${user}/.config/leftwm/themes/${theme}/theme.toml"
  '';
}
