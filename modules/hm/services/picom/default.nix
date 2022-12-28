{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.services.picom;
in
{
  options.modules.services.picom = {
    enable = mkEnableOption "picom compositor";
  };

  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      experimentalBackends = true; # For kawase blur
    };

    xdg.configFile."picom/picom.conf".source = ./picom.conf;
  };
}
