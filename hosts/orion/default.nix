{ config, lib, pkgs, ... }:

{ 
  imports = 
    [
      ../../modules/shell/fish
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

  modules.fish = {
    enableFlashyPrompt = false;
    enableFileIcons = false;
  };

  programs = {
    home-manager.enable = true;
  };
}
