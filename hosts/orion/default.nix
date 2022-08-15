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

    ../../config/shell/fish
    ../../config/programs
    ../../config/services/gpg

    ../../scripts
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

  modules.fish = {
    enable = true;
    enableFlashyPrompt = false;
    enableFileIcons = false;
  };

  modules.neovim.enable = true;

  programs = {
    home-manager.enable = true;
  };
}
