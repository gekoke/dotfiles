{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  imports = [
    ../modules/x11
    ../modules/terminal
    ../modules/shell
    ../modules/browser
    ../modules/programs
    ../modules/themes/gtk
    ../modules/services/gpg
    ../modules/editors/neovim
    ../modules/editors/code
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
}
