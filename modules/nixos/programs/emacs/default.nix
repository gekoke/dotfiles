{
  config,
  lib,
  pkgs,
  inputs,
  self,
  ...
}:
let
  inherit (self.lib.elementary) cat;
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    ;
  inherit (lib.types) package;
  cfg = config.elementary.programs.emacs;
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  options.elementary.programs.emacs = {
    enable = mkEnableOption "GNU Emacs";
    package = mkOption {
      type = package;
      default = pkgs.emacs;
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
      inherit (pkgs)
        noto-fonts-color-emoji
        ;
    };

    elementary.home.packages = [
      # keep-sorted start block=yes
      # LSP
      inputs.emacs-lsp-booster.packages.${pkgs.stdenv.hostPlatform.system}.default
      # age
      pkgs.age
      pkgs.cargo
      pkgs.clippy
      # CSharp
      pkgs.dotnet-sdk_10
      # dirvish
      pkgs.fd
      pkgs.ffmpegthumbnailer
      pkgs.gnutar
      # Go
      pkgs.go
      pkgs.gopls
      # jinx
      pkgs.hunspellDicts.en_US
      # Java
      pkgs.jdk25
      pkgs.jdt-language-server
      pkgs.mediainfo
      # lsp-nix
      pkgs.nixd
      pkgs.nixfmt
      # JavaScript/TypeScript
      pkgs.nodePackages.typescript
      # Tailwind CSS
      pkgs.nodejs
      pkgs.omnisharp-roslyn
      pkgs.poppler-utils # PDF preview
      # Powershell
      pkgs.powershell
      # Python
      pkgs.pyright
      # consult
      pkgs.ripgrep
      pkgs.ruff
      # Rust
      pkgs.rust-analyzer
      pkgs.rustc
      pkgs.rustfmt
      # Tofu
      pkgs.terraform # for terraform fmt
      pkgs.terraform-ls
      # Typst
      pkgs.tinymist
      pkgs.unzip
      pkgs.vips
      # HTML, CSS, JSON, Eslint
      pkgs.vscode-langservers-extracted
      # YAML
      pkgs.yaml-language-server
      # keep-sorted end
    ];

    elementary.home = {
      programs.emacs = {
        enable = true;
        inherit (cfg) package;
        extraConfig = ''
          (setq lsp-csharp-server-path "${pkgs.omnisharp-roslyn}/bin/OmniSharp")

          (setq lsp-pwsh-dir "${pkgs.powershell-editor-services}/lib/powershell-editor-services")

          (setq lsp-tailwindcss-server-path "${lib.getExe pkgs.tailwindcss-language-server}")

          (setq lsp-clients-typescript-tls-path "${lib.getExe pkgs.nodePackages.typescript-language-server}")
        '';
        extraPackages = epkgs: [
          # keep-sorted start block=yes
          (epkgs.lsp-mode.overrideAttrs (_: {
            env.LSP_USE_PLISTS = "true";
          }))
          epkgs.ace-window
          epkgs.age
          epkgs.cape
          epkgs.catppuccin-theme
          epkgs.consult
          epkgs.consult-lsp
          epkgs.corfu
          epkgs.dashboard
          epkgs.diff-hl
          epkgs.dired-gitignore
          epkgs.diredfl
          epkgs.dirvish
          epkgs.docker
          epkgs.doom-modeline
          epkgs.doom-themes
          epkgs.editorconfig
          epkgs.ef-themes
          epkgs.emacs
          epkgs.embark
          epkgs.embark-consult
          epkgs.envrc
          epkgs.evil
          epkgs.evil-anzu
          epkgs.evil-collection
          epkgs.evil-matchit
          epkgs.evil-mc
          epkgs.evil-numbers
          epkgs.evil-surround
          epkgs.evil-textobj-tree-sitter
          epkgs.eyebrowse
          epkgs.feature-mode
          epkgs.flycheck
          epkgs.forge
          epkgs.general
          epkgs.gruvbox-theme
          epkgs.hackernews
          epkgs.helpful
          epkgs.hl-todo
          epkgs.indent-bars
          epkgs.jinx
          epkgs.ligature
          epkgs.link-hint
          epkgs.lsp-java
          epkgs.lsp-pyright
          epkgs.lsp-tailwindcss
          epkgs.lsp-ui
          epkgs.magit
          epkgs.magit-todos
          epkgs.marginalia
          epkgs.markdown-mode
          epkgs.modus-themes
          epkgs.nerd-icons
          epkgs.nerd-icons-completion
          epkgs.nerd-icons-corfu
          epkgs.nix-ts-mode
          epkgs.nyan-mode
          epkgs.olivetti
          epkgs.orderless
          epkgs.package-lint
          epkgs.pdf-tools
          epkgs.powershell
          epkgs.python
          epkgs.rainbow-delimiters
          epkgs.remember-last-theme
          epkgs.rg
          epkgs.rustic
          epkgs.sideline-blame
          epkgs.terraform-mode
          epkgs.treesit-auto
          epkgs.treesit-grammars.with-all-grammars
          epkgs.typst-ts-mode
          epkgs.undo-tree
          epkgs.vertico
          epkgs.vterm
          epkgs.vterm-toggle
          epkgs.web-mode
          epkgs.wgrep
          epkgs.which-key
          epkgs.yaml-mode
          epkgs.yasnippet
          self.packages.${pkgs.stdenv.hostPlatform.system}.miasma-theme
          # keep-sorted end
        ];
      };
      file = {
        ".emacs.d/init.el".source = ./init.el;
        ".emacs.d/early-init.el".text = cat [
          ./early-init.el
          ./early-init-pgtk-fixes.el
        ];
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
