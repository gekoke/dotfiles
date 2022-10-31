{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = config.modules.services.dunst;
in
{
  options.modules.services.dunst = {
    enable = mkEnableOption "Dunst";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      configFile = ./dunstrc;
    };
  };
}
