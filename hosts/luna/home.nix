{pkgs, ...}: {
  xdg.enable = true;

  home.packages = with pkgs; [
    spotify
    discord
    teamspeak_client
    signal-desktop
  ];

  programs.git = {
    userName = "gekoke";
    userEmail = "gekoke@lazycantina.xyz";
  };
}
