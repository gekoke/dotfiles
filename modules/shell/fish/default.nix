{ lib, pkgs, ... }:
{
  home.packages = with pkgs;
  [
    lolcat
    neofetch
    boxes
    fortune
  ];

  xdg.configFile."fish/conf.d/".source = ./config/conf.d;

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
  };
}
