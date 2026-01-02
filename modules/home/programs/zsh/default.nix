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

  config = mkIf cfg.enable {
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

        # You are currently using the legacy default (home directory) because `home.stateVersion` is less than "26.05".
        # To silence this warning and lock in the current behavior, set:
        #   programs.zsh.dotDir = config.home.homeDirectory;
        # To adopt the new behavior (XDG config directory), set:
        #   programs.zsh.dotDir = "${config.xdg.configHome}/zsh";
        #
        # NOTE: I don't want to use that default right now, since my noshell module also wants the shell
        # as a file at `${con;ig.xdg.configHome}/zsh` and I'm not sure renaming the filename
        # from `zsh` to something else would be a good idea.
        dotDir = config.home.homeDirectory;
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
