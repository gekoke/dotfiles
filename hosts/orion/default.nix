{
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.stable;
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

  xdg.enable = true;

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
    emacs.enable = true;

    org.enable = true;
    comma.enable = true;
  };

  programs = {
    home-manager.enable = true;
  };
}
