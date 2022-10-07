{ pkgs, ... }: {
  services.picom = {
    enable = true;
    experimentalBackends = true; # For kawase blur
  };

  xdg.configFile."picom/picom.conf".source = ./picom.conf;
}
