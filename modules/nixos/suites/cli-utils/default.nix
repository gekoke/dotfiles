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
      neovim = enabled;
    };

    elementary.home.file.".parallel/will-cite".text = "";

    elementary.home.packages = [
      pkgs.btop
      pkgs.dos2unix
      pkgs.efibootmgr
      pkgs.exfat
      pkgs.jq
      pkgs.jwt-cli
      pkgs.moreutils # -> `sponge` et al
      pkgs.p7zip
      (lib.hiPrio pkgs.parallel-full) # `pkgs.moreutils` provides `parallel` binary as well
      pkgs.tldr
      pkgs.units
      pkgs.wget
      pkgs.zip
    ];
  };
}
