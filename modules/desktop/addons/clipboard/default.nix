{ config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.clipboard;
in
{
  options.plusultra.desktop.addons.clipboard = {
    enable = mkEnableOption "Wayland clipboard utilities and configuration";
  };

  config = mkIf cfg.enable {
    plusultra.home.packages = with pkgs; [
      wl-clipboard
      cliphist
    ];

    plusultra.home.shellAliases = {
      "cb" = "wl-copy";
      "cb1" = "wl-copy --paste-once";
      "cbo" = "wl-paste";
    };

    plusultra.home.extraOptions.systemd.user.services.cliphist = {
      Unit = {
        Description = "cliphist clipboard manager";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
