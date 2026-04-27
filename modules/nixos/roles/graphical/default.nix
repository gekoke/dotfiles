{
  inputs,
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.roles.graphical;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    genAttrs
    ;
  inherit (lib.types) nonEmptyListOf str;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    self.nixosModules.constants
  ];

  options.roles.graphical = {
    enable = mkEnableOption "the graphical role";
    forUsers = mkOption {
      type = nonEmptyListOf str;
      default = [ config.constants.default.user.name ];
    };
  };

  config = mkIf cfg.enable {
    home-manager.users = genAttrs cfg.forUsers (_: {
      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
      home.packages = [
        # pinentry-gnome3
        pkgs.gcr

        pkgs.discord
        pkgs.mpv
        pkgs.qbittorrent
        pkgs.spotify
      ];
    });

    # FIXME: make it work with `forUsers`
    elementary = {
      desktop.niri.enable = true;
      programs = {
        firefox.enable = true;
        kitty.enable = true;
      };
    };

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

    security.rtkit.enable = true;

    services = {
      pulseaudio.enable = lib.mkForce false;

      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };

      tzupdate.enable = true;
    };

    environment.systemPackages = [ pkgs.pavucontrol ];

    networking.networkmanager.enable = true;
  };
}
