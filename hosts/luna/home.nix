{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      spotify
      discord
      teamspeak_client
    ];

  programs.git = {
    userName = "gekoke";
    userEmail = "gekoke@lazycantina.xyz";
  };
}
