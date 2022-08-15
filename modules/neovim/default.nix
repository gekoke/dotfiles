{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.neovim;

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
  options.modules.neovim = {
    enable = mkEnableOption "NeoVim editor";
  };

  config = mkIf cfg.enable {
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
  };
}
