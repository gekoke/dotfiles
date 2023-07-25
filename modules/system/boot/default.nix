{ config, lib, ... }:

with lib;
let cfg = config.plusultra.system.boot;
in
{
  options.plusultra.system.boot = with types; {
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
