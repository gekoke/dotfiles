{ config, lib, ... }:

with lib;
let cfg = config.elementary.services.tzupdate;
in
{
  options.elementary.services.tzupdate = with types; {
    enable = mkEnableOption "automatic timezone updates";
  };

  config = mkIf cfg.enable { services.tzupdate.enable = true; };
}
