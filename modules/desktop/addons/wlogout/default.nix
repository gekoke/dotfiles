{ config, lib, ... }:
with lib;
let cfg = config.plusultra.desktop.addons.wlogout;
in
{
  options.plusultra.desktop.addons.wlogout = {
    enable = mkEnableOption "wlogout logout program";
  };

  config = mkIf cfg.enable {
    plusultra = {
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
