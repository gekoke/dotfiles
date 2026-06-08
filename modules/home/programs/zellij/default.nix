{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.zellij.elementary.config;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.programs.zellij.elementary.config = {
    enable = mkEnableOption "Elementary zellij configuration";
  };

  config = mkIf cfg.enable {
    programs.zellij.enable = true;

    # The home-manager `programs.zellij.settings` option renders to KDL via a
    # plain attrset, which cannot represent zellij's `keybinds clear-defaults`
    # block (with its `shared_among "a" "b"` node names). Ship the raw config
    # file instead; only values that differ from zellij's defaults are kept.
    xdg.configFile."zellij/config.kdl".source = ./config.kdl;
  };
}
