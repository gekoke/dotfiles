{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.dev.python;
in
{
  options.modules.dev.python = {
    enable = mkEnableOption "Python support";
  };

  config = mkIf cfg.enable {
  };
}
