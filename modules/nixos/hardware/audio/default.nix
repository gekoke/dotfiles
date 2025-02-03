{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
with lib.elementary;
let
  cfg = config.elementary.hardware.audio;
in
{
  options.elementary.hardware.audio = {
    enable = mkEnableOption "audio";
  };

  config = mkIf cfg.enable {
    security.rtkit = enabled;

    services.pipewire = enabled // {
      alsa = enabled // {
        support32Bit = true;
      };
      pulse = enabled;
      jack = enabled;
      wireplumber = enabled;
    };

    services.pulseaudio.enable = lib.mkForce false;

    elementary = {
      home.packages = [ pkgs.pavucontrol ];
      user.extraGroups = [ "audio" ];
    };
  };
}
