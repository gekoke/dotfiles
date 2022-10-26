{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.windowmanagers;
in {
  imports = [
    ./awesome
  ];

  options.modules.windowmanagers = {
    enable = mkEnableOption "window managers";
  };
}
