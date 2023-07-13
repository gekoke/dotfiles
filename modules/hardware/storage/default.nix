{ config, lib, ... }:

with lib;
let cfg = config.plusultra.hardware.storage;
in
{
  options.plusultra.hardware.storage = with types; {
    enable = mkEnableOption "common filesystem and storage support";
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems = [ "ntfs" ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

    swapDevices = [ ];
  };
}
