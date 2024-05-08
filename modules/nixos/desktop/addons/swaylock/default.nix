{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.elementary;
let
  cfg = config.elementary.desktop.addons.swaylock;
in
{
  # TODO: add theming
  options.elementary.desktop.addons.swaylock = {
    enable = mkEnableOption "swaylock lock menu";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.swaylock = enabled // {
      package = pkgs.swaylock-effects;
    };
    security.pam.services.swaylock.text = ''
      auth include login
    '';
  };
}
