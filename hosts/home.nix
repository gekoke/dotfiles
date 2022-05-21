{ config, lib, pkgs, user, ... }:

{ 
  imports = 
    [
      ../modules/x11
      ../modules/shell
      ../modules/terminal
      ../modules/browser
      ../modules/themes/gtk
      ../modules/programs

      ../modules/services/gpg
    ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "22.05";

    packages = with pkgs;
      [
        qutebrowser
        brave
        bitwarden
        neofetch
        spotify
        coreutils
      ];
    
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
