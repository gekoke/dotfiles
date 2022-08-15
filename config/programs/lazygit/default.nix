{pkgs, ...}: {
  home.packages = with pkgs; [lazygit];

  programs.zsh.shellAliases = {
    lg = "lazygit";
  };
  programs.fish.shellAliases = {
    lg = "lazygit";
  };
}
