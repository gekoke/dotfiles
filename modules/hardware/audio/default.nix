{ config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.hardware.audio;
in
{
  options.plusultra.hardware.audio = {
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

    plusultra.user.extraGroups = [ "audio" ];

    plusultra.home.packages = with pkgs; [
      pavucontrol
      easyeffects
    ];

    plusultra.home.services.mpd.extraConfig = ''
      audio_output {
        type "pipewire"
        name "pipewire_mpd_output"
      }
    '';
  };
}
