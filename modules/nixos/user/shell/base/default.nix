{ config, pkgs, lib, ... }:
with lib;
with lib.elementary;
let cfg = config.elementary.user.shell.zsh;
in
{
  options.elementary.user.shell.base = {
    enable = mkEnableOption "base shell configurations";
  };

  config = mkIf cfg.enable {
    elementary.home.programs = {
      starship = {
        enable = true;
        settings.username.show_always = true;
      };
      eza = {
        enable = true;
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
