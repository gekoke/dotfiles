{ config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.cursor;
in
{
  options.plusultra.desktop.addons.cursor = with types; {
    enable = mkEnableOption "cursor configuration";
  };

  config = mkIf cfg.enable {
    plusultra.home.extraOptions.home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
      gtk = enabled;
      x11 = enabled;
    };
  };
}
