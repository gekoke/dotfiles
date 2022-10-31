{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.hardware.gpu.nvidia;
in {
  options.modules.hardware.gpu.nvidia = {
    enable = mkEnableOption "NVidia support";
    digitalVibrance = mkOption {
      type = types.int;
      default = 0;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      videoDrivers = [ "nvidia" ];
      displayManager.sessionCommands = ''
        nvidia-settings --assign="DigitalVibrance=${cfg.digitalVibrance}" &
      '';
    };
  };
}
