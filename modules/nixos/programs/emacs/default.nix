{
  elementaryPackages,
  agenix,
  emacs-lsp-booster,
  ...
}:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) package;
  inherit (lib) concatStringsSep;
  inherit (builtins) readFile;
  cfg = config.elementary.programs.emacs;
in
{
  imports = [ agenix.nixosModules.default ];

  options.elementary.programs.emacs = {
    enable = mkEnableOption "GNU Emacs";
    package = mkOption {
      type = package;
      default = pkgs.emacs30;
    };
  };

  config = mkIf cfg.enable {
    # LSP optimizations
    environment.sessionVariables.LSP_USE_PLISTS = "true";

    fonts.packages = builtins.attrValues {
      inherit (pkgs.nerd-fonts)
        agave
        blex-mono
        fira-code
        iosevka-term
        jetbrains-mono
        ;
    };

    elementary.home.packages = [
      # jinx
      pkgs.hunspellDicts.en_US
      # dirvish
      pkgs.fd
      pkgs.vips
      pkgs.ffmpegthumbnailer
      pkgs.mediainfo
      pkgs.gnutar
      pkgs.unzip
      pkgs.poppler-utils # PDF preview
      # consult
      pkgs.ripgrep
      # LSP
      emacs-lsp-booster.packages.${pkgs.system}.default
      # lsp-nix
      pkgs.nil
      pkgs.nixfmt-rfc-style
      # age
      pkgs.age
      # YAML
      pkgs.yaml-language-server
      # HTML, CSS, JSON, Eslint
      pkgs.vscode-langservers-extracted
      # HTML, CSS (emmet)
      pkgs.emmet-language-server
      # Tailwind CSS
      pkgs.nodejs
      # Python
      pkgs.pyright
      pkgs.ruff
      # Java
      pkgs.jdk23
      pkgs.jdt-language-server
      # JavaScript/TypeScript
      pkgs.nodePackages.typescript
      pkgs.nodePackages.typescript-language-server
      # CSharp
      pkgs.omnisharp-roslyn
      # Rust
      pkgs.rust-analyzer
      pkgs.rustc
      pkgs.cargo
      pkgs.rustfmt
      pkgs.clippy
      # Go
      pkgs.go
      pkgs.gopls
      # Typst
      pkgs.tinymist
      # Tofu
      pkgs.terraform-ls
      # Powershell
      pkgs.powershell
    ];

    elementary.home = {
      programs.emacs = {
        enable = true;
        inherit (cfg) package;
        extraConfig = ''
          (setq lsp-csharp-server-path "${pkgs.omnisharp-roslyn}/bin/OmniSharp")

          (setq lsp-pwsh-dir "${pkgs.powershell-editor-services}/lib/powershell-editor-services")
        '';
        extraPackages = epkgs: [
          elementaryPackages.${pkgs.system}.miasma-theme
          elementaryPackages.${pkgs.system}.typst-ts-mode

          epkgs.treesit-grammars.with-all-grammars
          epkgs.general
          epkgs.undo-tree
          epkgs.ace-window
          epkgs.eyebrowse
          epkgs.indent-bars
          epkgs.jinx
          epkgs.nerd-icons
          epkgs.package-lint
          epkgs.doom-modeline
          epkgs.nyan-mode
          epkgs.dashboard
          epkgs.doom-themes
          epkgs.ef-themes
          epkgs.gruvbox-theme
          epkgs.modus-themes
          epkgs.catppuccin-theme
          epkgs.remember-last-theme
          epkgs.ligature
          epkgs.rainbow-delimiters
          epkgs.olivetti
          epkgs.which-key
          epkgs.rg
          epkgs.wgrep
          epkgs.embark
          epkgs.vertico
          epkgs.marginalia
          epkgs.nerd-icons-completion
          epkgs.orderless
          epkgs.consult
          epkgs.embark-consult
          epkgs.helpful
          epkgs.evil
          epkgs.evil-collection
          epkgs.evil-anzu
          epkgs.evil-numbers
          epkgs.evil-surround
          epkgs.evil-matchit
          epkgs.evil-mc
          epkgs.evil-textobj-tree-sitter
          epkgs.link-hint
          epkgs.pdf-tools
          epkgs.dirvish
          epkgs.dired-gitignore
          epkgs.diredfl
          epkgs.cape
          epkgs.corfu
          epkgs.emacs
          epkgs.nerd-icons-corfu
          epkgs.vterm
          epkgs.vterm-toggle
          epkgs.magit
          epkgs.magit-todos
          epkgs.forge
          epkgs.diff-hl
          epkgs.hl-todo
          epkgs.projectile
          epkgs.consult-projectile
          epkgs.envrc
          epkgs.flycheck
          epkgs.treesit-auto
          epkgs.yasnippet
          (epkgs.lsp-mode.overrideAttrs (_: {
            env.LSP_USE_PLISTS = "true";
          }))
          epkgs.lsp-ui
          epkgs.consult-lsp
          epkgs.nix-ts-mode
          epkgs.lsp-pyright
          epkgs.python
          epkgs.lsp-java
          epkgs.rustic
          epkgs.markdown-mode
          epkgs.web-mode
          epkgs.emacs
          epkgs.emacs
          epkgs.yaml-mode
          epkgs.terraform-mode
          epkgs.feature-mode
          epkgs.typst-ts-mode
          epkgs.lsp-tailwindcss
          epkgs.powershell
          epkgs.age
          epkgs.hackernews
          epkgs.sideline-blame
        ];
      };
      file = {
        ".emacs.d/init.el".source = ./init.el;
        ".emacs.d/early-init.el".text =
          let
            earlyInitText = concatStringsSep "\n" [
              (readFile ./early-init.el)
              (readFile ./early-init-pgtk-fixes.el)
            ];
          in
          earlyInitText;
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
