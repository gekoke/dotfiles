{ config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.desktop.addons.swww;
in
{
  options.plusultra.desktop.addons.swww = {
    enable = mkEnableOption "swww";
  };

  config = mkIf cfg.enable {
    plusultra.home.packages = [ pkgs.swww ];

    plusultra.home.extraOptions.systemd.user.services.swww = {
      Unit = {
        Description = "swww";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "always";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
