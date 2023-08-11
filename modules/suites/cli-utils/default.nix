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
    security.wrappers.pumount = {
      setuid = true;
      source = "${pkgs.pmount}/bin/pumount";
      owner = "root";
      group = "root";
    };

    plusultra.home.packages = with pkgs; [
      nix-index
      comma
      tldr
      neovim
      btop
      pmount
    ];

    environment.shellAliases."v" = "nvim";
  };
}
