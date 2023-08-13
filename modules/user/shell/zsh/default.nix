{ config, pkgs, lib, ... }:
with lib;
let cfg = config.plusultra.user.shell.zsh;
in
{
  options.plusultra.user.shell.zsh = {
    enable = mkEnableOption "ZSH shell";
  };

  config = mkIf cfg.enable {
    programs.zsh = enabled;
    users.users.${config.plusultra.user.name}.shell = pkgs.zsh;

    plusultra.home.programs = {
      zsh = {
        enable = true;
        syntaxHighlighting = enabled;
        enableAutosuggestions = true;
        autocd = true;
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
