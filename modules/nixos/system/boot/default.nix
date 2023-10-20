{ config, lib, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.system.boot;
in
{
  options.elementary.system.boot = with types; {
    enable = mkEnableOption "automatic bootloader support";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        configurationLimit = 100;
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
      };
    };
  };
}
