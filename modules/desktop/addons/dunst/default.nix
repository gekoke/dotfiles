{ config, lib, options, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.dunst;
in
{
  options.plusultra.desktop.addons.dunst = with types; {
    enable = mkEnableOption "dunst notification client";
    settings = mkOpt attrs { } "Settings to pass to dunst";
  };

  config = mkIf cfg.enable {
    plusultra.home.services.dunst = {
      enable = true;
      settings = mkAliasDefinitions options.plusultra.desktop.addons.dunst.settings;
    };
  };
}
