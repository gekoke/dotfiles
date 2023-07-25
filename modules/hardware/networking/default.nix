{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.hardware.networking;
in
{
  options.plusultra.hardware.networking = with types; {
    enable = mkEnableOption "networking support";
  };

  config = mkIf cfg.enable {
    plusultra.user.extraGroups = [ "networkmanager" ];
    networking.networkmanager.enable = true;
  };
}
