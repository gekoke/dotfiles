{ config, lib, ... }:
with lib;
with lib.elementary;
let
  cfg = config.elementary.security.sudo;
in
{
  options.elementary.security.sudo = {
    enable = mkEnableOption "sudo configuration";
  };

  config = mkIf cfg.enable { security.sudo.wheelNeedsPassword = false; };
}
