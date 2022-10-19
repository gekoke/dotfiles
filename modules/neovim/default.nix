{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.neovim;
in
{
  options.modules.neovim = {
    enable = mkEnableOption "NeoVim";
    enableNix = mkEnableOption "Nix language support";
    colorscheme = mkOption {
      type = types.str;
      default = "darkblue";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs = {
        neovim = {
          enable = true;
          plugins = with pkgs.vimPlugins; [
            # Themes
            gruvbox
            nord-vim

            # Functionality
            vim-airline

            # Language
            nvim-lspconfig
            (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
          ];

          extraConfig = ''
            luafile ${builtins.toString ./init.lua}

            lua << EOF
            local colorscheme = "${cfg.colorscheme}"
            vim.cmd("colorscheme " .. colorscheme)
            EOF
          '';
        };

        fish.shellAliases.v = "nvim";
        zsh.shellAliases.v = "nvim";
      };
    }

    (mkIf config.modules.dev.nix.enable {
      home.packages = with pkgs; [ rnix-lsp ];
      programs.neovim = {
        plugins = with pkgs.vimPlugins; [ vim-nix ];
        extraConfig = "luafile ${builtins.toString ./nix.lua}";
      };
    })

    {
      programs.neovim = {
        plugins = with pkgs.vimPlugins; [ alpha-nvim ];
        extraConfig = "luafile ${builtins.toString ./alpha-nvim.lua}";
      };
    }

    {
      programs.neovim = {
        plugins = with pkgs.vimPlugins; [ gitsigns-nvim ];
        extraConfig = "luafile ${builtins.toString ./gitsigns-nvim.lua}";
      };
    }
  ]);
}
