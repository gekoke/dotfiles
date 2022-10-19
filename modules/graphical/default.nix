{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.graphical;
in {
  options.modules.graphical = {
    enable = mkEnableOption "graphical environment support";
  };
}
