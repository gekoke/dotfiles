{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.suites.cli-utils;
in
{
  options.plusultra.suites.cli-utils = with types; {
    enable = mkEnableOption "CLI utilities";
  };

  config = mkIf cfg.enable {
    plusultra.home.packages = with pkgs; [
      nix-index
      comma
      tldr
      neovim
      btop
    ];

    environment.shellAliases."v" = "nvim";
  };
}
