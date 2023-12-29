{ config, lib, pkgs, ... }:
with lib;
with lib.elementary;
let cfg = config.elementary.programs.emacs;
in
{
  options.elementary.programs.emacs = {
    enable = mkEnableOption "GNU Emacs";
  };

  config =
    let
      emacsPackage = pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs-pgtk.override { withImageMagick = true; };
        config = ./init.el;
        alwaysEnsure = true;
        override = _final: prev: {
          lsp-mode = prev.melpaPackages.lsp-mode.overrideAttrs (_old: {
            LSP_USE_PLISTS = "true";
          });
        };
        extraEmacsPackages = epkgs: with epkgs; [
          treesit-grammars.with-all-grammars
          pkgs.elementary.kanagawa-theme
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
        # consult
        ripgrep
        # magit-delta
        delta
        # lsp-nix
        nil
        nixpkgs-fmt
        # age
        rage
        # parinfer-rust-mode
        parinfer-rust
        # YAML
        yaml-language-server
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

      age.secrets.emacsAuthinfo = lib.mkIf config.elementary.secrets.enable {
        file = ./authinfo.age;
        owner = config.elementary.user.name;
        path = "${config.users.users.${config.elementary.user.name}.home}/.authinfo";
        mode = "700";
      };
    };
}
