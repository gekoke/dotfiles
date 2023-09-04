{ config, lib, ... }:
with lib;
let cfg = config.elementary.desktop.addons.wlogout;
in
{
  options.elementary.desktop.addons.wlogout = {
    enable = mkEnableOption "wlogout logout program";
  };

  config = mkIf cfg.enable {
    elementary = {
      home.programs.wlogout.enable = true;

      desktop = {
        addons.swaylock = enabled;
        hyprland.extraHomeManagerOptions.extraConfig = ''
          bind = SUPER, Q, exec, pkill wlogout || wlogout -p layer-shell
        '';
      };
    };
  };
}
