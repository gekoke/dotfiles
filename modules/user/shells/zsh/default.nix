{ config, pkgs, lib, ... }:
with lib;
{
  options.plusultra.user.shells.zsh = {
    enable = mkEnableOption "ZSH shell";
  };

  config = {
    programs.zsh = enabled;
    users.users.${config.plusultra.user.name}.shell = pkgs.zsh;
    environment.pathsToLink = [ "/share/zsh" ];

    plusultra.home.programs = {
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        history = {
          size = I64_MAX; # In memory 
          save = I64_MAX; # Saved to file
        };

        # Must come before fzf to not conflict with fzf's keybinds
        initExtraFirst = ''
          ZVM_INIT_MODE=sourcing
          . ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        '';
      };
    };
  };
}
