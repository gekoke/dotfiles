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
    ../config/editors/code
    ../scripts
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

  modules.fish.enable = true;

  modules.code = {
    enable = true;
    enableRust = true;
  };

  modules.neovim.enable = true;
}
