{ pkgs, ... }: {
  imports = [
    ../../modules
  ];

  home.packages = with pkgs; [
    spotify
    discord
    teamspeak_client
    signal-desktop
    element-desktop
  ];

  programs.git = {
    userName = "gekoke";
    userEmail = "gekoke@lazycantina.xyz";
  };
}
