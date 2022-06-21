{ pkgs, lib, ... }:
{
  programs = {
    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins;
        [
          gruvbox
          vim-airline
          nvim-treesitter
          vim-nix
        ];
      extraConfig = ''
        lua << EOF
        ${lib.strings.fileContents ./init.lua}
        EOF
      '';
    };
 
    fish.shellAliases = {
      v = "nvim";
    };
    zsh.shellAliases = {
      v = "nvim";
    };
  };  
} 

