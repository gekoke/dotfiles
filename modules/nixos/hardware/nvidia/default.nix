{ config, lib, ... }:

with lib;
with lib.elementary;
let
  cfg = config.elementary.hardware.nvidia;
in
{
  options.elementary.hardware.nvidia = with types; {
    enable = mkEnableOption "NVIDIA configuration";
  };

  config = mkIf cfg.enable {
    hardware = {
      graphics.enable = true;

      nvidia = {
        # Modesetting is required
        modesetting.enable = true;
        powerManagement.enable = true;
        open = false;
        nvidiaSettings = true;
      };
    };
  };
}
