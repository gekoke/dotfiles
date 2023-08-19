{ config, lib, pkgs, inputs, ... }:
with lib;
let cfg = config.plusultra.desktop.addons.swww;
in
{
  options.plusultra.desktop.addons.swww = {
    enable = mkEnableOption "swww";
  };

  # TODO: add wallpaper picker script that pipes
  # wallpaper package images to rofi
  config =
    let
      # FIXME: remove when image automatically loading on startup is fixed
      swww = (import inputs.pinned-swww { system = pkgs.system; }).swww;
    in
    mkIf cfg.enable {
      plusultra.home.packages = [ swww ];

      plusultra.home.extraOptions.systemd.user.services.swww = {
        Unit = {
          Description = "swww";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${swww}/bin/swww-daemon";
          Restart = "always";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
