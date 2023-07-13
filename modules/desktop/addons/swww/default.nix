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
        WantedBy = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecCondition = ''
          ${pkgs.bash}/bin/bash -c '[ -n "$WAYLAND_DISPLAY" ]'
        '';

        ExecStart = ''
          ${pkgs.swww}/bin/swww init
        '';

        ExecReload = ''
          ${pkgs.swww}/bin/swww kill; ${pkgs.swww}/bin/swww init
        '';

        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
