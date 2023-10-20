{ config, lib, pkgs, inputs, ... }:
with lib;
with lib.elementary;
let cfg = config.elementary.programs.ranger;
in
{
  options.elementary.programs.ranger = {
    enable = mkEnableOption "ranger terminal file browser";
  };

  config = mkIf cfg.enable {
    elementary.home.packages = [ pkgs.ranger ];

    elementary.home.configFile."ranger/rc.conf".text = ''
      set preview_images true
      set preview_images_method kitty
      default_linemode devicons
    '';

    elementary.home.configFile."ranger/plugins/ranger_devicons" = {
      source = inputs.ranger-devicons.outPath;
      recursive = true;
    };

    elementary.home.shellAliases."ra" = "ranger";
  };
}
