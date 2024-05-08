{ config, lib, ... }:

with lib;
with lib.elementary;
let
  cfg = config.elementary.hardware.filesystems;
in
{
  options.elementary.hardware.filesystems = with types; {
    enable = mkEnableOption "common filesystem support";
  };

  config = mkIf cfg.enable { boot.supportedFilesystems = [ "ntfs" ]; };
}
