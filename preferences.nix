{ lib
, mylib
, ...
}:
with lib;
with mylib; let
  inherit (mylib.color) palette;
in
{
  options.prefs = {
    style = {
      palette = mkOption {
        type = palette;
        default = (import ./modules/palettes).nord;
      };
    };
  };
}
