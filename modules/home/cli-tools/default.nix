{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.elementary.cli-tools;
  inherit (lib) hiPrio mkEnableOption mkIf;
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
        # keep-sorted start
        (hiPrio pkgs.parallel-full) # `pkgs.moreutils` provides `parallel` binary as well
        (mkIf osConfig.virtualisation.docker.enable pkgs.docker-compose)
        pkgs.bat
        pkgs.btop
        pkgs.dig
        pkgs.dos2unix
        pkgs.efibootmgr
        pkgs.exfat
        pkgs.jq
        pkgs.jwt-cli
        pkgs.moreutils # -> `sponge` et al
        pkgs.p7zip
        pkgs.tldr
        pkgs.units
        pkgs.wget
        pkgs.xxd
        pkgs.zip
        # keep-sorted end
      ];
    };
  };
}
