{ config, lib, ... }:
with lib;
with lib.elementary;
let
  cfg = config.elementary.programs.neovim;
in
{
  options.elementary.programs.neovim = {
    enable = mkEnableOption "Neovim text editor";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.neovim = {
      enable = true;
      extraLuaConfig = builtins.readFile ./init.lua;
    };

    elementary.home.shellAliases."v" = "nvim";
  };
}
