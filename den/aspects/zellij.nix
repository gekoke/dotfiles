{
  den.aspects.zellij.provides.to-users.homeManager = {
    programs.zellij.enable = true;
    # HM's `programs.zellij.settings` renders KDL from a plain attrset, which
    # can't express zellij's `keybinds clear-defaults` block (with its
    # `shared_among "a" "b"` node names). Ship the raw config file instead;
    # only values that differ from zellij's defaults are kept.
    xdg.configFile."zellij/config.kdl".source = ./zellij.kdl;
  };
}
