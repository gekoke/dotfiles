{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      spotify
      discord
      teamspeak_client
    ];
}
