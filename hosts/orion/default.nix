{ config, lib, pkgs, ... }:

{ 
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
    };
  };

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
    enable = true;
    enableFlashyPrompt = false;
    enableFileIcons = false;
  };

  programs = {
    home-manager.enable = true;
  };
}
