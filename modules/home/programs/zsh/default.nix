{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.programs.zsh.elementary.config;
  inherit (lib) mkEnableOption mkIf;
  inherit (self.lib) I64_MAX;
in
{
  imports = [
    self.homeModules."programs.noshell"
  ];

  options.programs.zsh.elementary.config = {
    enable = mkEnableOption "Elementary zsh shell configuration";
  };

  config = mkIf (cfg.enable && config.programs.zsh.enable) {
    home.packages = [ pkgs.trash-cli ];

    programs = {
      noshell = {
        enable = true;
        shellPackage = pkgs.zsh;
      };
      zsh = {
        shellAliases.dl = "trash";
        syntaxHighlighting.enable = true;
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
}
