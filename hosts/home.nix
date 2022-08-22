{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  imports = [
    ../config/x11
    ../config/terminal
    ../config/browser
    ../config/programs
    ../config/themes/gtk
    ../config/services/gpg

    ../modules
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "22.05";

    packages = with pkgs; [
      bitwarden
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

  modules = {
    fish.enable = true;
    code = {
      enable = true;
      enableRust = true;
    };
    neovim = {
      enable = true;
      enableNix = true;
      colorscheme = "gruvbox";
    };

    comma.enable = true;
    emacs.enable = true;
  };
}
