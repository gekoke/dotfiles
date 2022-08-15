{
  pkgs,
  lib,
  ...
}: let
  themes = with pkgs.vimPlugins; [
    gruvbox
  ];

  language = with pkgs.vimPlugins; [
    (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
    vim-nix
  ];

  functionality = with pkgs.vimPlugins; [
    vim-airline
    alpha-nvim
    gitsigns-nvim
  ];
in {
  programs = {
    neovim = {
      enable = true;
      plugins = themes ++ language ++ functionality;

      extraConfig = ''
        lua << EOF
        ${lib.strings.fileContents ./init.lua}
        EOF
      '';
    };

    fish.shellAliases.v = "nvim";
    zsh.shellAliases.v = "nvim";
  };
}
