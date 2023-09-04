{ config, lib, ... }:

with lib;
let cfg = config.elementary.hardware.filesystems;
in
{
  options.elementary.hardware.filesystems = with types; {
    enable = mkEnableOption "common filesystem support";
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems = [ "ntfs" ];
  };
}
