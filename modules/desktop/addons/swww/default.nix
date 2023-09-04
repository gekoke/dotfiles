{ config, lib, pkgs, inputs, ... }:
with lib;
let cfg = config.elementary.desktop.addons.swww;
in
{
  options.elementary.desktop.addons.swww = {
    enable = mkEnableOption "swww";
  };

  config =
    let
      # FIXME: remove when image automatically loading on startup is fixed
      swww = (import inputs.pinned-swww { system = pkgs.system; }).swww;
    in
    mkIf cfg.enable {
      elementary.home.packages = [ swww ];

      elementary.home.file."Pictures/Wallpapers" = {
        source = "${pkgs.wallpapers}/share/wallpapers";
        recursive = true;
      };

      elementary.home.extraOptions.systemd.user.services.swww = {
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
