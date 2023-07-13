{ config, lib, ... }:
with lib;
let cfg = config.plusultra.system.keyboard;
in
{
  options.plusultra.system.keyboard = with types; {
    enable = mkEnableOption "keyboard layouts";
  };

  config = mkIf cfg.enable {
    plusultra.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      input {
          kb_layout = ee
          kb_variant = us
          kb_options = caps:ctrl_modifier
      }
    '';
  };
}
