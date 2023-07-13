{ config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.virtualisation.podman;
in
{
  options.plusultra.virtualisation.podman = {
    enable = mkEnableOption "Podman";
  };

  config = mkIf cfg.enable {
    plusultra.home.packages = [ pkgs.podman-compose ];
    plusultra.home.extraOptions.shellAliases."docker-compose" = "podman-compose";
    virtualisation.podman = enabled // { dockerCompat = true; };
  };
}
