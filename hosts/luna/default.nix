{
  config,
  pkgs,
  lib,
  user,
  ...
}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  boot.loader.grub.gfxmodeEfi = "1920x1080";

  networking = {
    hostName = "luna";

    wireless.enable = false;

    useDHCP = false; # Deprecated - set to false, then override to true per interface
    interfaces = {
      enp7s0 = {
        useDHCP = true;
      };
    };
  };

  imports = [
    ./hardware-configuration.nix
    ../../config/system/hardware/nvidia
    ../../config/system/services/steam
  ];

  boot.kernelParams = [
    #  TODO: Try to get lightdm to play nice
    #  "video=HDMI-0:1920x1080@239.96"
    "video=HDMI-0:1920x1080"
  ];

  services.xserver.displayManager.sessionCommands = ''
    xrandr --output HDMI-0 --mode 1920x1080 --rate 239.96 &
  '';
}
