{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.loginmanagers.lightdm;
in {
  options.modules.loginmanagers.lightdm = {
    enable = mkEnableOption "lightdm login manager";
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.lightdm = {
      enable = true;
      greeters.gtk.enable = true;
    };
  };
}
