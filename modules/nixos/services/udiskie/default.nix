{ config, lib, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.services.udiskie;
in
{
  options.elementary.services.udiskie = with types; {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    services.udisks2 = enabled;
    elementary.home.services.udiskie = enabled;
  };
}
