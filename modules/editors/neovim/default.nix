{ pkgs, lib, ... }:
let
  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  plugin = pluginGit "HEAD";

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

    (plugin "lewis6991/gitsigns.nvim")
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

