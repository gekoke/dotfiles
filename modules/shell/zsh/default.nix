{ ... }:
{
  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
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
}
