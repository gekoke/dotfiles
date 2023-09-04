{ config, lib, pkgs, ... }:
with lib;
let cfg = config.elementary.programs.emacs;
in
{
  options.elementary.programs.emacs = {
    enable = mkEnableOption "GNU Emacs";
  };

  config =
    let
      emacsPackage = pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs29-pgtk;
        config = ./init.el;
        alwaysEnsure = true;
        override = final: prev: {
          lsp-mode = prev.melpaPackages.lsp-mode.overrideAttrs (old: {
            LSP_USE_PLISTS = "true";
          });
        };
        extraEmacsPackages = epkgs: with epkgs; [
          treesit-grammars.with-all-grammars
        ];
      };
      earlyInitText = readFiles [
        ./early-init.el
        ./early-init-pgtk-fixes.el
      ];
    in
    mkIf cfg.enable {
      # LSP optimizations
      environment.sessionVariables.LSP_USE_PLISTS = "true";

      fonts.packages = with pkgs; [
        # all-the-icons
        emacs-all-the-icons-fonts
      ];

      elementary.home.packages = with pkgs; [
        # dirvish
        fd
        imagemagick
        ffmpegthumbnailer
        mediainfo
        gnutar
        unzip
        xpdf
        # consult
        ripgrep
        # lsp-nix
        nil
        nixpkgs-fmt
        # age
        rage
        # parinfer-rust-mode
        parinfer-rust
        # lsp-haskell
        haskell-language-server
        ghc
        # YAML
        yaml-language-server
        # html-mode, css-mode etc
        nodePackages.vscode-langservers-extracted
        # JS/TS
        nodePackages.typescript-language-server
      ];

      elementary.home = {
        programs.emacs = {
          enable = true;
          package = emacsPackage;
          extraConfig = ''
            (setq parinfer-rust-library "${pkgs.parinfer-rust}/lib/libparinfer_rust.so")
          '';
        };
        file = {
          ".emacs.d/init.el".source = ./init.el;
          ".emacs.d/early-init.el".text = earlyInitText;
        };
      };

      age.secrets.emacsAuthinfo = {
        file = ./authinfo.age;
        owner = config.elementary.user.name;
        path = "${config.users.users.${config.elementary.user.name}.home}/.authinfo";
        mode = "700";
      };
    };
}
