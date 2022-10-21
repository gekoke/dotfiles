{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.dev.c;
in
{
  options.modules.dev.c = {
    enable = mkEnableOption "C language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ clang ];
  };
}
