{ config
, lib
, mylib
, pkgs
, inputs
, ...
}:
with lib;
with mylib; let
  cfg = config.modules.editors.emacs;

  doomSetupScript = pkgs.writeShellScriptBin "doominit" ''
    git clone --depth=1 --single-branch https://github.com/doomemacs/doomemacs "$XDG_CONFIG_HOME/emacs"
    doom install
  '';

  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-basic
      dvisvgm
      dvipng# For preview and export as HTML
      wrapfig
      amsmath
      ulem
      hyperref
      capt-of
      ;
  };

  loadFeature = name: {
    xdg = {
      enable = true;
      configFile = {
        "doom/init.el".text = readFileOrNil ./features/${name}/init.el;
        "doom/config.el".text = readFileOrNil ./features/${name}/config.el;
        "doom/packages.el".text = readFileOrNil ./features/${name}/packages.el;
      };
    };
  };
in
{
  options.modules.editors.emacs = {
    enable = mkEnableOption "Doom Emacs";
  };

  config = mkMergeIf cfg.enable [
    (loadFeature "base-config")
    {
      programs.emacs.enable = true;

      xdg = {
        enable = true;
        configFile."doom/" = {
          source = ./config;
          recursive = true;
        };
      };

      home = {
        packages = with pkgs; [
          doomSetupScript

          # Doom dependencies
          git
          (ripgrep.override { withPCRE2 = true; })
          gnutls # for TLS connectivity

          # Optional dependencies
          fd # faster projectile indexing
          imagemagick # for image-dired
          zstd # for undo-fu-session/undo-tree compression

          # Module dependencies
          pandoc # Markdown
          tex # :lang latex & :lang org (latex previews)
          (aspellWithDicts (ds: with ds; [ en en-computers en-science et ])) # :checkers spell
          editorconfig-core-c # :tools editorconfig
          sqlite # :tools lookup & :lang org +roam

          # My base-config
          direnv
        ];
        sessionPath = [ "${config.home.sessionVariables.XDG_CONFIG_HOME}/emacs/bin" ];
      };
    }

    (mkMerge [
      {
        programs.emacs.extraPackages = epkgs: with epkgs; [ vterm ];
        home = {
          packages = with pkgs; [
            cmake
            gnumake
          ];
          sessionVariables.CC = "make";
        };
      }
      (loadFeature "vterm")
      # TODO Use Doom emacs straight package! for vterm
      # See: https://github.com/NixOS/nixpkgs/issues/194929
    ])

    # Dirvish
    (mkMerge [
      {
        home.packages = with pkgs;  [
          fd # As a faster alternative to find
          mediainfo # For audio/video metadata generation
          gnutar # For archive files preview
          unzip
        ];
      }
      (mkIf config.modules.graphical.enable {
        home.packages = with pkgs; [
          imagemagick # For image preview
          ffmpegthumbnailer # For video preview
          xpdf # For PDF preview
        ];
        nixpkgs.config.permittedInsecurePackages = [
          "xpdf-4.04"
        ];
      })
      (loadFeature "dirvish")
    ])

    (mkIf config.modules.graphical.enable {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        emacs-all-the-icons-fonts
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            "FiraCode"
            "Iosevka"
          ];
        })
      ];
    })

    (mkMergeIf config.modules.graphical.enable [
      {
        programs.emacs.extraPackages = epkgs: with epkgs; [ pdf-tools ];
      }
      (loadFeature "pdf")
    ])

    (mkIf config.programs.rtorrent.enable (loadFeature "mentor"))

    (mkMergeIf config.modules.dev.nix.enable [
      {
        home.packages = with pkgs; [
          rnix-lsp
          nixpkgs-fmt
        ];
      }
      (loadFeature "nix")
    ])

    (mkMergeIf config.modules.dev.c.enable [
      {
        xdg.configFile."doom/config.el".text = "(setq lsp-clangd-binary-path \"${pkgs.clang}/bin/clang\")";
      }
      (loadFeature "c")
    ])

    (mkIf config.modules.services.email.enable (loadFeature "mu4e"))

    (mkIf config.modules.dev.prolog.enable (loadFeature "prolog"))

    (mkMergeIf config.modules.dev.python.enable [
      { home.packages = with config.modules.dev.python.packages; [ python-lsp-server ]; }
      (loadFeature "python")
    ])

    (mkMergeIf config.modules.dev.haskell.enable [
      {
        home.packages = with pkgs; [
          config.modules.dev.haskell.ghcPackage
          cabal-install
          haskell-language-server
        ];
      }
      (loadFeature "haskell")
    ])

    (mkMergeIf config.modules.dev.lua.enable [
      (
        let
          lsp = pkgs.sumneko-lua-language-server;
        in
        {
          home.packages = [ lsp ];
          xdg.configFile."doom/config.el".text = ''
            (after! lsp-mode
              (setq lsp-clients-lua-language-server-bin "${lsp}/bin/lua-language-server"))
          '';
        }
      )
      (loadFeature "lua")
    ])

    (mkMerge [
      { home.packages = with config.modules.dev.python.packages; [ rst2pdf ]; }
      (loadFeature "rst")
    ])

    (mkMerge [
      {
        programs.java = {
          enable = true;
          package = pkgs.jdk17;
        };
      }
      (loadFeature "java")
    ])

    (loadFeature "javascript")
    (loadFeature "web")
  ];
}
