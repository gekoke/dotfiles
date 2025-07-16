{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.elementary;
let
  inherit (lib.elementary) I64_MAX;
  cfg = config.elementary.user.shell.zsh;
in
{
  options.elementary.user.shell.zsh = {
    enable = mkEnableOption "ZSH shell";
  };

  config = mkIf cfg.enable {
    users.users.${config.elementary.user.name}.shell = pkgs.zsh;

    programs.zsh = enabled;

    elementary.home = {
      packages = [ pkgs.trash-cli ];

      programs = {
        zsh = {
          enable = true;
          shellAliases = {
            dl = "trash";
          };
          syntaxHighlighting = enabled;
          autosuggestion.enable = true;
          autocd = true;
          history = {
            size = I64_MAX; # In memory
            save = I64_MAX; # Saved to file
          };
          # Must come before fzf to not conflict with fzf's keybinds
          initContent = lib.mkBefore ''
            ZVM_INIT_MODE=sourcing
            . ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
          '';
        };
        eza = {
          enable = true;
          icons = "auto";
        };
        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
        starship = {
          enable = true;
          enableZshIntegration = true;
          settings.username.show_always = true;
        };
        atuin = {
          enable = true;
          enableZshIntegration = true;
          flags = [ "--disable-up-arrow" ];
          settings = {
            inline_height = 30;
            style = "compact";
          };
        };
      };
    };
  };
}
