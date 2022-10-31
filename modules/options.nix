{ lib, ... }:
{
  options.modules.graphical = {
    enable = lib.mkEnableOption "graphical environment support";
  };
}
