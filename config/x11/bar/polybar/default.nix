{ pkgs, ... }:
let
  myPolybar = pkgs.polybar.override {
    pulseSupport = true;
  };

  bars = builtins.readFile ./config/bars.ini;
  colors = builtins.readFile ./config/colors.ini;
  modules = builtins.readFile ./config/modules.ini;
  userModules = builtins.readFile ./config/user_modules.ini;

  spotifyModulePythonDeps = python-packages: with python-packages; [ dbus-python ];
  pythonWithDeps = pkgs.python38.withPackages spotifyModulePythonDeps;

  playerctl = pkgs.playerctl;

  polybarSpotifyScript = ./config/scripts/spotify_status.py;

  feather-icons = pkgs.callPackage ../../../../packages/icomoon-feather-ttf { };

  spotifyModule = ''
    [module/spotify]
    type = custom/script
    interval = 1
    format-prefix = " "
    format-prefix-foreground = ''${color.red}
    format = <label>
    exec = ${pythonWithDeps}/bin/python ${polybarSpotifyScript} -t 70 -f '{play_pause} {artist} • {song}' -p ','
    click-left = ${playerctl}/bin/playerctl --player=spotify play-pause
    click-right = ${playerctl}/bin/playerctl --player=spotify next
    click-middle = ${playerctl}/bin/playerctl --player=spotify previous
  '';
in
{
  home.packages = with pkgs; [
    playerctl

    material-icons
    feather-icons
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];
  fonts.fontconfig.enable = true;

  services = {
    polybar = {
      enable = true;
      package = myPolybar;
      config = ./config/config.ini;
      extraConfig = bars + colors + modules + userModules + spotifyModule;
      script = ''
        polybar main &
      '';
    };
  };
}
