{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.security.gpg;
in
{
  options.plusultra.security.gpg = with types; {
    enable = mkEnableOption "gnupg";
  };

  config = mkIf cfg.enable {
    services = {
      pcscd.enable = true; # Card readers n stuff
      dbus.packages = [ pkgs.gcr ];
    };

    plusultra.home = {
      programs.gpg = enabled;
      packages = [ pkgs.pinentry.gnome3 ];
      services.gpg-agent =
        let
          ttlInSeconds = 8 * 60 * 60;
        in {
          enable = true;
          pinentryFlavor = "gnome3";
          defaultCacheTtl = ttlInSeconds;
          maxCacheTtl = ttlInSeconds;
        };
    };
  };
}
