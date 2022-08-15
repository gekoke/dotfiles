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
    ../../config/shell/fish
    ../../config/programs

    ../../config/services/gpg
    ../../config/editors/neovim
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

  programs = {
    home-manager.enable = true;
  };
}
