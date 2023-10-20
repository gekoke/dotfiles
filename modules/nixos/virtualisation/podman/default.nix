{ config, lib, pkgs, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.virtualisation.podman;
in
{
  options.elementary.virtualisation.podman = {
    enable = mkEnableOption "Podman";
  };

  config = mkIf cfg.enable {
    elementary.home.packages = [ pkgs.podman-compose ];
    elementary.home.extraOptions.shellAliases."docker-compose" = "podman-compose";
    virtualisation.podman = enabled // { dockerCompat = true; };
  };
}
