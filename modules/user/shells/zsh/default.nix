{ config, pkgs, lib, ... }:
with lib;
{
  options.plusultra.user.shells.zsh = {
    enable = mkEnableOption "ZSH shell";
  };

  config = {
    programs.zsh = enabled;
    users.users.${config.plusultra.user.name}.shell = pkgs.zsh;

    plusultra.home.programs = {
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;

       initExtra = ''
         source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
       '';
      };
    };
  };
}
