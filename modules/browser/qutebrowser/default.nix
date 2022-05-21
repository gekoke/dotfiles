{ pkgs, ... }:
{
  home.packages = with pkgs; [ qutebrowser ];
}
