{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.elementary;
let
  cfg = config.elementary.desktop.addons.keyring;
in
{
  options.elementary.desktop.addons.keyring = with types; {
    enable = mkEnableOption "keyring graphical interface";
  };

  config = mkIf cfg.enable { elementary.home.packages = [ pkgs.seahorse ]; };
}
