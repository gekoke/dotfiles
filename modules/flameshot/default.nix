{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.flameshot;
in {
  options.modules.flameshot = {
    enable = mkEnableOption "Flameshot program";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [flameshot];
    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + shift + s" = "flameshot gui";
        "super + shift + a" = "flameshot screen --clipboard";
      };
    };
  };
}
