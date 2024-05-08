{ config, lib, ... }:

with lib;
with lib.elementary;
let
  cfg = config.elementary.services.tzupdate;
in
{
  options.elementary.services.tzupdate = with types; {
    enable = mkEnableOption "automatic timezone updates";
  };

  config = mkIf cfg.enable { services.tzupdate.enable = true; };
}
