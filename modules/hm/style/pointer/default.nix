{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.style.pointer;
in
{
  options.modules.style.pointer = {
    enable = mkEnableOption "pointer theme";
  };

  config = mkIf cfg.enable {
    home = {
      pointerCursor = {
        x11.enable = true;
        gtk.enable = true;

        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 22;
      };
    };
  };
}
