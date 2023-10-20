{ config, lib, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.hardware.nvidia;
in
{
  options.elementary.hardware.nvidia = with types; {
    enable = mkEnableOption "NVIDIA configuration";
    digitalVibranceLevel =
      mkOpt (ints.between - 1024 1023) 1023 "Digital vibrance level - integer between -1024 and 1023 (both inclusive)";
  };

  config = mkIf cfg.enable {
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      nvidia = {
        nvidiaSettings = true;
        # Modesetting is needed for most wayland compositors
        modesetting = enabled;
        # Allows all VRAM to be saved when suspending, not just some
        # powerManagement = enabled;
      };
    };
  };
}
