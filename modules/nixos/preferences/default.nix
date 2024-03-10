{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
in
{
  options.elementary.preferences = {
    allowLongCompilationTimes = mkOption {
      type = bool;
      default = false;
    };
  };
}
