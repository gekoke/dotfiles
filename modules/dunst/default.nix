{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = config.modules.dunst;
in
{
  options.modules.dunst = {
    enable = mkEnableOption "Dunst";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      configFile = ./dunstrc;
    };
  };
}
