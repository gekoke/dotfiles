{ config, lib, ... }:

with lib;
with lib.elementary;
let
  cfg = config.elementary.suites.desktop;
in
{
  options.elementary.suites.desktop = with types; {
    enable = mkEnableOption "common desktop configuration";
  };

  config = mkIf cfg.enable {
    elementary = {
      desktop.niri = enabled;

      programs.kitty = enabled;

      hardware = {
        filesystems = enabled;
        networking = enabled;
        audio = enabled;
      };

      services.tzupdate = enabled;
    };
  };
}
