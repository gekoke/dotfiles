{ config, lib, pkgs, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.virtualisation.docker;
in
{
  options.elementary.virtualisation.docker = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = enabled;
    environment.systemPackages = [
      pkgs.docker-compose
      pkgs.lazydocker
    ];
    elementary.user.extraGroups = [ "docker" ];
  };
}
