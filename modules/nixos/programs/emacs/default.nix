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

  config =
    let
      emacsPackage = pkgs.emacsWithPackagesFromUsePackage {
        inherit (cfg) package;
        config = ./init.el;
        alwaysEnsure = true;
        override = pkgs.callPackage ./overlay.nix { };
        extraEmacsPackages = epkgs: [
          epkgs.treesit-grammars.with-all-grammars
          pkgs.elementary.typst-ts-mode
          pkgs.elementary.kanagawa-theme
          pkgs.elementary.adwaita-dark-theme
          pkgs.elementary.anisochromatic
          pkgs.elementary.miasma-theme
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
        imagemagick
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
      ];

      elementary.home = {
        programs.emacs = {
          enable = true;
          package = emacsPackage;
          extraConfig = ''
            (setq lsp-clients-typescript-tls-path "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server")

            (setq lsp-csharp-server-path "${pkgs.omnisharp-roslyn}/bin/OmniSharp")
          '';
        };
        file = {
          ".emacs.d/init.el".source = ./init.el;
          ".emacs.d/early-init.el".text = earlyInitText;
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
