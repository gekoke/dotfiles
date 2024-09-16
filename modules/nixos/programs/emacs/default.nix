{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.elementary;
let
  cfg = config.elementary.programs.emacs;
in
{
  options.elementary.programs.emacs = {
    enable = mkEnableOption "GNU Emacs";
    package = mkOption {
      type = types.package;
      default =
        if config.elementary.preferences.allowLongCompilationTimes then
          # FIXME: make this `emacs-unstable-pgtk` once that points to Emacs 30
          # (you can check here: https://github.com/nix-community/emacs-overlay/blob/master/repos/emacs/emacs-unstable.json)
          # currently only using `emacs-pgtk` (which points to Git master branch)
          # for Emacs 30 stipple support for `indent-bars`
          pkgs.emacs-pgtk
        else
          pkgs.emacs29-pgtk;
    };
  };

  config =
    let
      emacsPackage = pkgs.emacsWithPackagesFromUsePackage {
        inherit (cfg) package;
        config = ./init.el;
        alwaysEnsure = true;
        override = pkgs.callPackage ./overlay.nix { };
        extraEmacsPackages = epkgs: [
          epkgs.treesit-grammars.with-all-grammars
          inputs.magit-file-icons.packages.${pkgs.system}.default
          pkgs.elementary.typst-ts-mode
          pkgs.elementary.kanagawa-theme
          pkgs.elementary.indent-bars
          pkgs.elementary.adwaita-dark-theme
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
        # jinx
        hunspellDicts.en_US
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
        nixfmt-rfc-style
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
        # Tailwind CSS
        nodejs
        # Python
        pyright
        ruff-lsp
        # Java
        jdk21
        jdt-language-server
        # JavaScript/TypeScript
        nodePackages.typescript
        nodePackages.typescript-language-server
        # Terraform
        terraform
        # CSharp
        omnisharp-roslyn
        # Rust
        rust-analyzer
        rustc
        cargo
        rustfmt
        clippy
        # Go
        go
        gopls
        # Typst
        typst-lsp
      ];

      elementary.home = {
        programs.emacs = {
          enable = true;
          package = emacsPackage;
          extraConfig = ''
            (setq lsp-java-server-install-dir "${pkgs.jdt-language-server}/share/java/jdtls")
            (setq lsp-java-server-config-dir (concat (file-name-as-directory (xdg-config-home)) "lsp-java/config_linux/")) 
            (add-to-list 'lsp-java-vmargs "-javaagent:${pkgs.elementary.lombok-jar}/share/java/lombok.jar")

            (setq lsp-clients-typescript-tls-path "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server")

            (setq lsp-csharp-server-path "${pkgs.omnisharp-roslyn}/bin/OmniSharp")
          '';
        };
        file = {
          ".emacs.d/init.el".source = ./init.el;
          ".emacs.d/early-init.el".text = earlyInitText;
          ".config/lsp-java/config_linux/config.ini".source = "${pkgs.jdt-language-server}/share/java/jdtls/config_linux/config.ini";
        };
      };

      age.secrets.emacsAuthinfo = lib.mkIf config.elementary.secrets.enable {
        file = ./../../../../secrets/authinfo.age;
        owner = config.elementary.user.name;
        path = "${config.users.users.${config.elementary.user.name}.home}/.authinfo";
        mode = "700";
      };
    };
}
