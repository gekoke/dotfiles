{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.dev.prolog;
in {
  options.modules.dev.csharp = {
    enable = mkEnableOption "SWI-Prolog support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swi-prolog
    ];
  };
}
