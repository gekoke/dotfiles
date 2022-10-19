{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.dev.haskell;
in {
  options.modules.dev.haskell = {
    enable = mkEnableOption "Haskell dev support";
    ghcPackage = mkOption {
      type = types.package;
      default = pkgs.haskell.compiler.ghc902;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.ghcPackage
      cabal-install
    ];
  };
}
