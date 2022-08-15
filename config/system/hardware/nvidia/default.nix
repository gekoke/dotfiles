{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    videoDrivers = ["nvidia"];
    displayManager.sessionCommands = ''
      nvidia-settings --assign="DigitalVibrance=1023" &
    '';
  };
}
