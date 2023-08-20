{ config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.desktop.addons.swaylock;
in
{
  # TODO: add theming
  options.plusultra.desktop.addons.swaylock = {
    enable = mkEnableOption "swaylock lock menu";
  };

  config = mkIf cfg.enable {
    plusultra.home.programs.swaylock = enabled // { package = pkgs.swaylock-effects; };
    security.pam.services.swaylock.text = ''
      auth include login
    '';
  };
}
