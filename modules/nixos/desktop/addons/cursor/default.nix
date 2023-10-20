{ config, lib, pkgs, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.desktop.addons.cursor;
in
{
  options.elementary.desktop.addons.cursor = with types; {
    enable = mkEnableOption "cursor configuration";
  };

  config = mkIf cfg.enable {
    elementary.home.extraOptions.home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
      gtk = enabled;
      x11 = enabled;
    };
  };
}
