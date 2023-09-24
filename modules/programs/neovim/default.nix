{ config, lib, ... }:
with lib;
let cfg = config.elementary.programs.neovim;
in
{
  options.elementary.programs.neovim = {
    enable = mkEnableOption "Neovim text editor";
    defaultEditor = mkEnableOption "Set neovim as the default editor";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.neovim = {
      enable = true;
      extraLuaConfig = builtins.readFile ./init.lua;
    };

    elementary.home.shellAliases."v" = "nvim";

    elementary.home.sessionVariables.EDITOR = mkIf cfg.defaultEditor "nvim";
  };
}
