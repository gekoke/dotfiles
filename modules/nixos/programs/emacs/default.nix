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
        override = pkgs.callPackage ./overlay.nix { };
        extraEmacsPackages = epkgs: [
          epkgs.treesit-grammars.with-all-grammars
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
        # HTML, CSS, JSON, Eslint
        vscode-langservers-extracted
        # HTML, CSS (emmet)
        emmet-language-server
        # Python
        nodePackages.pyright
        ruff-lsp
        # Java
        jdk21
        jdt-language-server
      ];

      elementary.home = {
        programs.emacs = {
          enable = true;
          package = emacsPackage;
          extraConfig = ''
            (setq lsp-java-server-install-dir "${pkgs.jdt-language-server}/share/java/jdtls")
            (setq lsp-java-server-config-dir (concat (file-name-as-directory (xdg-config-home)) "lsp-java/config_linux/")) 
            (add-to-list 'lsp-java-vmargs "-javaagent:${pkgs.elementary.lombok-jar}/share/java/lombok.jar")
          '';
        };
        file = {
          ".emacs.d/init.el".source = ./init.el;
          ".emacs.d/early-init.el".text = earlyInitText;
          ".config/lsp-java/config_linux/config.ini".source = "${pkgs.jdt-language-server}/share/java/jdtls/config_linux/config.ini";
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
