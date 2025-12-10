{
  config,
  lib,
  ...
}:

with lib;
with lib.elementary;
let
  cfg = config.elementary.hardware.networking;
in
{
  options.elementary.hardware.networking = with types; {
    enable = mkEnableOption "networking support";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
