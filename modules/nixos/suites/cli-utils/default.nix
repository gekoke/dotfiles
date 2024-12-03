{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.elementary;
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

    elementary.programs = {
      ranger = enabled;
      neovim = enabled // {
        defaultEditor = true;
      };
    };

    elementary.home.packages = [
      pkgs.zip
      pkgs.tldr
      pkgs.btop
      pkgs.pmount
      pkgs.exfat
      pkgs.wget
      pkgs.p7zip
      pkgs.jwt-cli
      pkgs.jq
    ];
  };
}
