{ lib, ... }:
{
  programs = {
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;

      shellAliases = {
        ll = "ls -l";
      };
    };
  };

  home.sessionVariables = {
    fish_prompt_pwd_dir_length = 0;
    fish_greeting = "";
  };
}
