{ pkgs, ... }: {
  xdg.configFile."ranger/rifle.conf".source = ./config/rifle.conf;
  xdg.configFile."ranger/rc.conf".source = ./config/rc.conf;
  xdg.configFile."ranger/scope.sh".source = ./config/scope.sh;

  home.packages = with pkgs; [
    ranger
    ueberzug
  ];

  programs.zsh.shellAliases = {
    ra = "ranger";
  };
  programs.fish.shellAliases = {
    ra = "ranger";
  };
}
