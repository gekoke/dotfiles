{
  config,
  lib,
  pkgs,
  system,
  inputs,
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
      default = pkgs.emacs30;
    };
  };

  config = mkIf cfg.enable {
    # LSP optimizations
    environment.sessionVariables.LSP_USE_PLISTS = "true";

    fonts.packages = [
      pkgs.nerd-fonts.iosevka-term
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.blex-mono
      pkgs.nerd-fonts.fira-code
    ];

    elementary.home.packages = with pkgs; [
      # jinx
      hunspellDicts.en_US
      # dirvish
      fd
      vips
      ffmpegthumbnailer
      mediainfo
      gnutar
      unzip
      # consult
      ripgrep
      # LSP
      inputs.emacs-lsp-booster.packages.${system}.default
      # lsp-nix
      nil
      nixfmt-rfc-style
      # age
      rage
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
      ruff
      # Java
      jdk23
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
      tinymist
      # Tofu
      pkgs.terraform-ls
      # Powershell
      pkgs.powershell
      # R
      (rWrapper.override {
        packages = [
          pkgs.rPackages.languageserver
          pkgs.rPackages.haven
          pkgs.rPackages.dplyr
          pkgs.rPackages.ggplot2
          pkgs.rPackages.tidyr
          pkgs.rPackages.broom
          pkgs.rPackages.readr
          pkgs.rPackages.car
          pkgs.rPackages.lmtest
          pkgs.rPackages.interactions
          pkgs.rPackages.forcats
          pkgs.rPackages.zip
          pkgs.rPackages.labelled
          pkgs.rPackages.survey
        ];
      })
      # Copilot LSP
      pkgs.copilot-language-server
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
          pkgs.elementary.typst-ts-mode
          pkgs.elementary.kanagawa-theme
          pkgs.elementary.adwaita-dark-theme
          pkgs.elementary.anisochromatic
          pkgs.elementary.miasma-theme

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
          epkgs.vscode-dark-plus-theme
          epkgs.ef-themes
          epkgs.apropospriate-theme
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
          epkgs.forge
          epkgs.diff-hl
          epkgs.blamer
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
          epkgs.lsp-mode
          epkgs.lsp-mode
          epkgs.typst-ts-mode
          epkgs.lsp-mode
          epkgs.lsp-tailwindcss
          epkgs.powershell
          epkgs.ess
          epkgs.age
          epkgs.hackernews
          epkgs.rfc-mode
        ];
      };
      file = {
        ".emacs.d/init.el".source = ./init.el;
        ".emacs.d/early-init.el".text =
          let
            earlyInitText = readFiles [
              ./early-init.el
              ./early-init-pgtk-fixes.el
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
