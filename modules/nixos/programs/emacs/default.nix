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
  elementaryEmacsPackages = [
    # keep-sorted start
    self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs-completion
    self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs-editor
    self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs-keys
    self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs-prelude
    self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs-themes
    self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs-vc
    self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs-visual
    self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs-workspaces
    # keep-sorted end
  ];
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

    elementary.home.extraOptions.fonts.fontconfig.enable = true;

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
      # Java
      pkgs.jdk25
      pkgs.jdt-language-server
      pkgs.mediainfo
      # Fonts
      pkgs.nerd-fonts.agave
      pkgs.nerd-fonts.blex-mono
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.iosevka-term
      pkgs.nerd-fonts.jetbrains-mono
      # lsp-nix
      pkgs.nixd
      pkgs.nixfmt
      # Tailwind CSS
      pkgs.nodejs
      pkgs.noto-fonts-color-emoji
      pkgs.omnisharp-roslyn
      pkgs.poppler-utils # PDF preview
      # Powershell
      pkgs.powershell
      # Python
      pkgs.pyright
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
        extraConfig =
          let
            execPath = pkgs.buildEnv {
              name = "elementary-emacs-exec-path";
              pathsToLink = [ "/bin" ];
              paths = lib.map lib.getBin (
                [
                  # JavaScript/TypeScript
                  pkgs.typescript
                ]
                ++ lib.concatMap (p: p.runtimeDeps or [ ]) elementaryEmacsPackages
              );
            };
          in
          ''
            (setq lsp-csharp-server-path "${pkgs.omnisharp-roslyn}/bin/OmniSharp")

            (setq lsp-pwsh-dir "${pkgs.powershell-editor-services}/lib/powershell-editor-services")

            (setq lsp-tailwindcss-server-path "${lib.getExe pkgs.tailwindcss-language-server}")

            (setq lsp-clients-typescript-tls-path "${lib.getExe pkgs.typescript-language-server}")

            (setq exec-path (append '("${execPath}/bin") exec-path))
          '';
        overrides = _final: prev: {
          lsp-mode = prev.lsp-mode.override {
            melpaBuild = args: prev.melpaBuild (args // { env.LSP_USE_PLISTS = "true"; });
          };

          magit = prev.magit.override {
            melpaBuild =
              args:
              prev.melpaBuild (
                args
                // {
                  # Try out syntax highlighting - see https://github.com/magit/magit/issues/2942#issuecomment-4093865954
                  # FIXME: remove pin
                  src = pkgs.fetchFromGitHub {
                    owner = "gekoke";
                    repo = "magit";
                    rev = "c3cb836320d4ec491fa7168718218f46a61293dc";
                    hash = "sha256-htq1A6lr+iJunhl8mqyKpbAaaNZ2XZoBYDGDqoVtJSg=";
                  };
                }
              );
          };
        };
        extraPackages =
          epkgs:
          [
            # keep-sorted start block=yes
            epkgs.age
            epkgs.consult-lsp
            epkgs.dired-gitignore
            epkgs.diredfl
            epkgs.dirvish
            epkgs.docker
            epkgs.emacs
            epkgs.envrc
            epkgs.feature-mode
            epkgs.flycheck
            epkgs.hackernews
            epkgs.lsp-java
            epkgs.lsp-mode
            epkgs.lsp-pyright
            epkgs.lsp-tailwindcss
            epkgs.lsp-ui
            epkgs.markdown-mode
            epkgs.nix-ts-mode
            epkgs.package-lint
            epkgs.pdf-tools
            epkgs.powershell
            epkgs.python
            epkgs.rustic
            epkgs.sideline-blame
            epkgs.terraform-mode
            epkgs.treesit-auto
            epkgs.treesit-grammars.with-all-grammars
            epkgs.typst-ts-mode
            epkgs.vterm
            epkgs.vterm-toggle
            epkgs.web-mode
            epkgs.yaml-mode
            epkgs.yasnippet
            # keep-sorted end
          ]
          ++ elementaryEmacsPackages;
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
