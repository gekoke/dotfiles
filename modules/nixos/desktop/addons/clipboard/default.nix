{ config, lib, pkgs, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.desktop.addons.clipboard;
in
{
  options.elementary.desktop.addons.clipboard = {
    enable = mkEnableOption "Wayland clipboard utilities and configuration";
  };

  config = mkIf cfg.enable {
    elementary.home.packages = with pkgs; [
      wl-clipboard
      cliphist
    ];

    elementary.home.shellAliases = {
      "cb" = "wl-copy";
      "cb1" = "wl-copy --paste-once";
      "cbo" = "wl-paste";
    };

    elementary.home.extraOptions.systemd.user.services.cliphist = {
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
