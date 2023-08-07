{ pkgs, lib, ... }:

with lib;
{
  options.plusultra.user.shells.base = {
    enable = mkEnableOption "base shell configurations";
  };

  config = {
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
