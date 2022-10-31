{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.browsers.brave;
in
{
  options.modules.browsers.brave = {
    enable = mkEnableOption "Brave";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ brave ];
  };
}
