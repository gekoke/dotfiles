{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.elementary.programs.comma;
in
{
  options.elementary.programs.comma = {
    enable = mkEnableOption "comma program";
  };

  config = mkIf cfg.enable {
    elementary.home.packages = with pkgs; [
      comma
      nix-index
    ];

    # Needed on a flake-based system as nix-index requires Nix channels
    nix = {
      nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
      channel = enabled;
    };
  };
}
