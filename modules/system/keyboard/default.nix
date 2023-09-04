{ config, lib, ... }:
with lib;
let cfg = config.elementary.system.keyboard;
in
{
  options.elementary.system.keyboard = with types; {
    enable = mkEnableOption "keyboard layouts";
  };

  config = mkIf cfg.enable {
    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      input {
          kb_layout = ee
          kb_variant = us
          kb_options = caps:ctrl_modifier
      }
    '';
  };
}
