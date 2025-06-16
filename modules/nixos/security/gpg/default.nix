{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.elementary;
let
  cfg = config.elementary.security.gpg;
in
{
  options.elementary.security.gpg = with types; {
    enable = mkEnableOption "gnupg";
    pinentryPackage = mkOption {
      type = nullOr package;
      default = pkgs.pinentry-gnome3;
    };
  };

  config = mkIf cfg.enable {
    services = {
      pcscd.enable = true; # Card readers n stuff
      dbus.packages = [ pkgs.gcr ];
    };

    elementary.home = {
      programs.gpg = enabled;
      services.gpg-agent =
        let
          ttlInSeconds = 8 * 60 * 60;
        in
        {
          enable = true;
          pinentry.package = cfg.pinentryPackage;
          defaultCacheTtl = ttlInSeconds;
          maxCacheTtl = ttlInSeconds;
        };
    };
  };
}
