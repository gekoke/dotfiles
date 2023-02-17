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
    package = mkOption {
      type = types.package;
      default = pkgs.python39;
    };
    packages = mkOption {
      type = types.attrs;
      default = pkgs.python39Packages;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
    ];
  };
}
