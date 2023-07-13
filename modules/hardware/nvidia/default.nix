{ config, lib, ... }:

with lib;
let cfg = config.plusultra.hardware.nvidia;
in
{
  options.plusultra.hardware.nvidia = with types; {
    enable = mkEnableOption "NVIDIA configuration";
    digitalVibranceLevel =
      mkOpt (ints.between - 1024 1023) 1023 "Digital vibrance level - integer between -1024 and 1023 (both inclusive)";
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.sessionCommands = ''
      nvidia-settings --assign="DigitalVibrance=${toString cfg.digitalVibranceLevel}" &
    '';

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
        powerManagement = enabled;
      };
    };

    # Allows all VRAM to be saved when suspending, not just some
    boot.extraModprobeConfig = ''
      options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp/nvidia-vidmem
    '';
  };
}
