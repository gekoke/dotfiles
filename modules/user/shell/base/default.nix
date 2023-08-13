{ config, pkgs, lib, ... }:
with lib;
let cfg = config.plusultra.user.shell.zsh;
in
{
  options.plusultra.user.shell.base = {
    enable = mkEnableOption "base shell configurations";
  };

  config = mkIf cfg.enable {
    plusultra.home.programs = {
      starship = enabled;
      exa = {
        enable = true;
        enableAliases = true;
        icons = true;
      };
    };

    plusultra.home.packages = with pkgs; [
      gnugrep
      trash-cli
    ];
    plusultra.home.shellAliases = {
      i = "grep -i";
      x = "grep";
      dl = "trash";
    };
  };
}
