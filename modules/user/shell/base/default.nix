{ config, pkgs, lib, ... }:
with lib;
let cfg = config.elementary.user.shell.zsh;
in
{
  options.elementary.user.shell.base = {
    enable = mkEnableOption "base shell configurations";
  };

  config = mkIf cfg.enable {
    elementary.home.programs = {
      starship = enabled;
      exa = {
        enable = true;
        enableAliases = true;
        icons = true;
      };
    };

    elementary.home.packages = with pkgs; [
      gnugrep
      trash-cli
    ];
    elementary.home.shellAliases = {
      i = "grep -i";
      x = "grep";
      dl = "trash";
    };
  };
}
