{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.shells.zsh;
in {
  options.modules.shells.zsh = {
    enable = mkEnableOption "Module description";
  };

  config = mkIf cfg.enable {
    programs = {
      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = false;
          hostname = {
            ssh_only = false;
          };
          username = {
            show_always = true;
          };
        };
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      zsh = {
        enable = true;

        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;

        history = {
          size = 100000000;
        };

        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
        };

        shellAliases = {
          ll = "ls -l";
        };
      };
    };
  };
}
