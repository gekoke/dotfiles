{ config, lib, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.multimedia;
in
{
  options.plusultra.desktop.addons.multimedia = with types; {
    enable = mkEnableOption "media services";
    volumeStep = mkOpt (number.between 0 100) 1 "the percentage to step volume by";
  };

  config = mkIf cfg.enable {
    plusultra.home.services.mpd = enabled;

  };
}
