{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.hom.windowmanagers;
in {
  imports = [
    ./awesome
  ];

  options.modules.hom.windowmanagers = {
    enable = mkEnableOption "window managers";
  };
}
