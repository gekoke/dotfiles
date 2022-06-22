{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      spotify
      teamspeak_client
    ];
}
