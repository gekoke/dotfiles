{ config, lib, ... }:
with lib;
let cfg = config.plusultra.security.sudo;
in
{
  options.plusultra.security.sudo = {
    enable = mkEnableOption "sudo configuration";
  };

  config = mkIf cfg.enable {
    security.sudo.wheelNeedsPassword = false;
  };
}
