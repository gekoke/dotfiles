{
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
    };
  };

  imports = [
    ../../modules

    ../../config/programs
    ../../config/services/gpg
  ];

  home = {
    stateVersion = "22.05";

    packages = with pkgs; [
      neofetch
      coreutils
      tldr
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  modules = {
    fish = {
      enable = true;
      enableFlashyPrompt = false;
      enableFileIcons = false;
    };
    neovim = {
      enable = true;
      enableNix = true;
      colorscheme = "gruvbox";
    };
    scripts.enable = true;
    comma.enable = true;
  };

  programs = {
    home-manager.enable = true;
  };
}
