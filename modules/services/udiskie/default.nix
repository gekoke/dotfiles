{ config, lib, ... }:

with lib;
let cfg = config.plusultra.services.udiskie;
in
{
  options.plusultra.services.udiskie = with types; {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    services.udisks2 = enabled;
    plusultra.home.services.udiskie = enabled;
  };
}
