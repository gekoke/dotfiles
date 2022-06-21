{ config, lib, pkgs, user, ... }:

{ 
  imports = 
    [
      ../modules/x11
      ../modules/shell
      ../modules/terminal
      ../modules/browser
      ../modules/programs
      ../modules/themes/gtk

      ../modules/services/gpg

      ../modules/editors/neovim
    ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "22.05";

    packages = with pkgs;
      [
        bitwarden
        neofetch
        spotify
        coreutils
      ];
    
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
