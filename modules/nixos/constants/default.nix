{
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    ;
  inherit (lib.types) str;
in
{
  options.constants = {
    default.user.name = mkOption {
      type = str;
      default = "geko";
    };
  };
}
