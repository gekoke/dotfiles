{ config
, lib
, pkgs
, user
, ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../config/x11
    ../config/terminal
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

    sessionVariables.EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  services = {
    unclutter = {
      enable = true;
      timeout = 5;
    };
  };

  modules = {
    windowmanagers.awesome.enable = true;
    graphical.enable = true;

    dev = {
      nix.enable = true;
      c.enable = true;
      prolog.enable = true;
      haskell.enable = true;
    };
    code.enable = true;
    browsers = {
      enable = true;
      default = "qutebrowser";
      qutebrowser.enable = true;
      firefox.enable = true;
    };
    fish = {
      enable = true;
      enableFlashyPrompt = true;
      enableFileIcons = true;
    };
    neovim = {
      enable = true;
      enableNix = true;
      colorscheme = "nord";
    };

    emacs.enable = true;
    org.enable = true;
    comma.enable = true;
    flameshot.enable = true;
    dunst.enable = true;
    mediakeys.enable = true;
    email.enable = true;
    netutils.enable = true;
  };
}
