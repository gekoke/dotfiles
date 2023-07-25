{ config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.keyring;
in
{
  options.plusultra.desktop.addons.keyring = with types; {
    enable = mkEnableOption "keyring graphical interface";
  };

  config = mkIf cfg.enable {
    plusultra.home.packages = [ pkgs.gnome.seahorse ];
  };
}
