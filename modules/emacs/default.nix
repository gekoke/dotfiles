{ config
, lib
, mylib
, pkgs
, inputs
, ...
}:
with lib; let
  inherit (mylib.file) readFileOrNil;
  inherit (mylib.core) mkMergeIf;

  cfg = config.modules.emacs;

  doomSetupScript = pkgs.writeShellScriptBin "doominit" ''
    git clone --depth=1 --single-branch https://github.com/doomemacs/doomemacs "$XDG_CONFIG_HOME/emacs"
    doom install
  '';

  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-basic
      dvisvgm
      dvipng # For preview and export as HTML
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
in {
  options.modules.emacs = {
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
          (aspellWithDicts (ds: with ds; [ en en-computers en-science ])) # :checkers spell
          editorconfig-core-c # :tools editorconfig
          sqlite # :tools lookup & :lang org +roam
        ];
        sessionPath = [ "${config.home.sessionVariables.XDG_CONFIG_HOME}/emacs/bin" ];
      };
    }

    (mkMerge [
      {
        home = {
          packages = with pkgs; [
            cmake
            gnumake
            clang
          ];
          sessionVariables.CC = "clang";
        };
      }
      (loadFeature "vterm")
    ])

    (mkIf (!config.modules.graphical.enable) (loadFeature "ranger"))

    (mkMergeIf config.modules.graphical.enable [
      {
        fonts.fontconfig.enable = true;

        home.packages = with pkgs; [
          emacs-all-the-icons-fonts
          (nerdfonts.override {
            fonts = [
              "JetBrainsMono"
              "FiraCode"
            ];
          })
        ];
      }
      (loadFeature "pdf")
      (loadFeature "ranger+icons")
    ])


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

    (mkIf config.modules.email.enable (loadFeature "mu4e"))

    (mkIf config.modules.dev.prolog.enable (loadFeature "prolog"))
  ];
}
