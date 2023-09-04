{ config, lib, ... }:

with lib;
let cfg = config.elementary.hardware.storage;
in
{
  options.elementary.hardware.storage = with types; {
    enable = mkEnableOption "common filesystem and storage support";
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems = [ "ntfs" ];
  };
}
