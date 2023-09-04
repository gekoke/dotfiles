{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.elementary.suites.cli-utils;
in
{
  options.elementary.suites.cli-utils = with types; {
    enable = mkEnableOption "CLI utilities";
  };

  config = mkIf cfg.enable {
    security.wrappers.pumount = {
      setuid = true;
      source = "${pkgs.pmount}/bin/pumount";
      owner = "root";
      group = "root";
    };

    elementary.home.packages = with pkgs; [
      nix-index
      comma
      tldr
      neovim
      btop
      pmount
      exfat
    ];

    elementary.home.shellAliases."v" = "nvim";
  };
}
