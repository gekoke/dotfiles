{ pkgs, ... }:
{
  imports =
    [
      ./git
      ./ranger
      ./lazygit
    ];
    
  home.packages = with pkgs;
    [
      ncpamixer
    ];
}
