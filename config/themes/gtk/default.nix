{ pkgs, ... }: {
  home = {
    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;

      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 22;
    };
  };
}
