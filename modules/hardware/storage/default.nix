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
  };
}
