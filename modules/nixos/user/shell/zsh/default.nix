{ config, pkgs, lib, ... }:
with lib;
with lib.elementary;
let cfg = config.elementary.user.shell.zsh;
in
{
  options.elementary.user.shell.zsh = {
    enable = mkEnableOption "ZSH shell";
  };

  config = mkIf cfg.enable {
    programs.zsh = enabled;
    users.users.${config.elementary.user.name}.shell = pkgs.zsh;

    elementary.home.programs = {
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
