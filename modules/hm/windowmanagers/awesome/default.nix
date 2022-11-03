{ lib
, config
, ...
}:
with lib; let
  cfg = config.modules.windowmanagers.awesome;
in {
  options.modules.windowmanagers.awesome = {
    enable = mkEnableOption "awesomewm";
  };

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      windowManager.awesome.enable = true;
    };
    xdg.configFile."awesome/rc.lua".source = ./rc.lua;
  };
}
