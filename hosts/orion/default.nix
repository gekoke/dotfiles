{ config, lib, pkgs, ... }:

{ 
  imports = 
    [
      ../../modules/shell
      ../../modules/programs
            
      ../../modules/services/gpg
      ../../modules/editors/neovim
    ];

  home = {
    stateVersion = "22.05";

    packages = with pkgs;
      [
        neofetch
        coreutils
        tldr
      ];
    
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
