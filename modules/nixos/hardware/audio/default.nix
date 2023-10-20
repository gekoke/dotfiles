{ config, pkgs, lib, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.hardware.audio;
in
{
  options.elementary.hardware.audio = {
    enable = mkEnableOption "audio";
  };

  config = mkIf cfg.enable {
    security.rtkit = enabled;

    services.pipewire = enabled // {
      alsa = enabled;
      pulse = enabled;
      jack = enabled;
      wireplumber = enabled;
    };

    hardware.pulseaudio.enable = mkForce false;

    elementary.user.extraGroups = [ "audio" ];

    elementary.home.packages = with pkgs; [
      pavucontrol
      easyeffects
    ];

    elementary.home.services.mpd.extraConfig = ''
      audio_output {
        type "pipewire"
        name "pipewire_mpd_output"
      }
    '';
  };
}
