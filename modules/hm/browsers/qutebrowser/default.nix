{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.browsers.qutebrowser;
in
{
  options.modules.browsers.qutebrowser = {
    enable = mkEnableOption "Qutebrowser";
  };

  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      extraConfig = builtins.readFile ./config.py;
    };
  };
}
