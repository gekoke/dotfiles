{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.dev.nix;
in
{
  options.modules.dev.nix = {
    enable = mkEnableOption "Nix dev support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rnix-lsp
      nixpkgs-fmt
    ];
  };
}
