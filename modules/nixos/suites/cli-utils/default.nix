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
    elementary.programs = {
      ranger = enabled;
      neovim = enabled // {
        defaultEditor = true;
      };
    };

    elementary.home.packages = [
      pkgs.btop
      pkgs.efibootmgr
      pkgs.exfat
      pkgs.jq
      pkgs.jwt-cli
      pkgs.p7zip
      pkgs.tldr
      pkgs.units
      pkgs.wget
      pkgs.zip
    ];
  };
}
