{ den, inputs, ... }:
{
  den.schema.flake-system.includes = [ den.aspects.packages ];

  den.aspects.packages.packages =
    { pkgs, system, ... }:
    let
      pkgs-emacs = import inputs.nixpkgs-emacs {
        inherit system;
      };
      pkgs-emacs-packages = import inputs.nixpkgs-emacs-packages {
        inherit system;
      };
      pkgs-emacs-runtime = import inputs.nixpkgs-emacs-runtime {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (pkgs.lib.getName pkg) [
            "claude-code"
            "terraform"
          ];
      };

      mkElementaryEmacs =
        emacs:
        let
          emacsPackages = pkgs-emacs-packages.emacsPackagesFor emacs;
          callPackage =
            path: extraArgs:
            pkgs-emacs-runtime.callPackage path ({ inherit emacsPackages; } // elementaryPackages // extraArgs);
          elementaryPackages = {
            # keep-sorted start block=yes
            elementary-emacs-agents = callPackage ../../packages/elementary-emacs-agents { };
            elementary-emacs-completion = callPackage ../../packages/elementary-emacs-completion { };
            elementary-emacs-csharp = callPackage ../../packages/elementary-emacs-csharp { };
            elementary-emacs-editor = callPackage ../../packages/elementary-emacs-editor { };
            elementary-emacs-files = callPackage ../../packages/elementary-emacs-files { };
            elementary-emacs-java = callPackage ../../packages/elementary-emacs-java { };
            elementary-emacs-keys = callPackage ../../packages/elementary-emacs-keys { };
            elementary-emacs-lsp = callPackage ../../packages/elementary-emacs-lsp { };
            elementary-emacs-markdown = callPackage ../../packages/elementary-emacs-markdown { };
            elementary-emacs-nix = callPackage ../../packages/elementary-emacs-nix { };
            elementary-emacs-prelude = callPackage ../../packages/elementary-emacs-prelude { };
            elementary-emacs-python = callPackage ../../packages/elementary-emacs-python { };
            elementary-emacs-rust = callPackage ../../packages/elementary-emacs-rust { };
            elementary-emacs-terminal = callPackage ../../packages/elementary-emacs-terminal { };
            elementary-emacs-themes = callPackage ../../packages/elementary-emacs-themes { };
            elementary-emacs-vc = callPackage ../../packages/elementary-emacs-vc { };
            elementary-emacs-visual = callPackage ../../packages/elementary-emacs-visual {
              auto-olivetti = emacsPackages.callPackage ../../packages/auto-olivetti { };
            };
            elementary-emacs-web = callPackage ../../packages/elementary-emacs-web { };
            elementary-emacs-workspaces = callPackage ../../packages/elementary-emacs-workspaces { };
            # keep-sorted end
          };
        in
        pkgs-emacs-runtime.callPackage ../../packages/elementary-emacs (
          elementaryPackages // { inherit emacs emacsPackages; }
        );
    in
    {
      # keep-sorted start block=yes
      auto-olivetti = pkgs-emacs-packages.emacsPackages.callPackage ../../packages/auto-olivetti { };
      elementary-emacs = mkElementaryEmacs pkgs-emacs.emacs;
      elementary-emacs-pgtk = mkElementaryEmacs pkgs-emacs.emacs-pgtk;
      lombok-jar = pkgs.callPackage ../../packages/lombok-jar { };
      wallpapers = pkgs.callPackage ../../packages/wallpapers { };
      # keep-sorted end
    };
}
