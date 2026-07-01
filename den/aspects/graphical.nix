{ den, ... }:
{
  den.aspects.graphical = {
    includes = [
      den.aspects.niri
      den.aspects.firefox
      den.aspects.kitty
    ];

    nixos =
      { pkgs, lib, ... }:
      {
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

    provides.to-users.includes = [
      (den.batteries.unfree [
        "discord"
        "discord-unwrapped"
        "spotify"
      ])
    ];

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
        home.packages = [
          pkgs.gcr_4 # pinentry-gnome3 dependency
          pkgs.discord
          pkgs.mpv
          pkgs.qbittorrent
          pkgs.spotify
        ];
      };
  };
}
