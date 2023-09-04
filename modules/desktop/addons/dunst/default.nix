{ config, lib, options, ... }:

with lib;
let cfg = config.elementary.desktop.addons.dunst;
in
{
  options.elementary.desktop.addons.dunst = with types; {
    enable = mkEnableOption "dunst notification client";
    settings = mkOpt attrs { } "Settings to pass to dunst";
  };

  config = mkIf cfg.enable {
    elementary.home.services.dunst = {
      enable = true;
      settings = mkAliasDefinitions options.elementary.desktop.addons.dunst.settings;
    };
  };
}
