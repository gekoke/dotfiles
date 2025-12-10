{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = config.elementary.cli-tools;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.elementary.cli-tools = {
    enable = mkEnableOption "CLI tools";
  };

  config = mkIf cfg.enable {
    home = {
      file = {
        ".parallel/will-cite".text = "";
      };

      packages = [
        pkgs.bat
        pkgs.btop
        pkgs.dig
        (lib.mkIf osConfig.virtualisation.docker.enable pkgs.docker-compose)
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
        pkgs.xxd
      ];
    };
  };
}
