{ config, lib, ... }:

with lib;
let cfg = config.plusultra.services.tzupdate;
in
{
  options.plusultra.services.tzupdate = with types; {
    enable = mkEnableOption "automatic timezone updates";
  };

  config = mkIf cfg.enable { services.tzupdate.enable = true; };
}
