rec {
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org?priority=41"
      "https://gekoke-dotfiles.cachix.org?priority=42"
      "https://niri.cachix.org?priority=43"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "gekoke-dotfiles.cachix.org-1:mED8HYGwRLMcDvi54a/Qxl5LshQtOXRt3rlXHw4GkDw="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  inputs = {
    # keep-sorted start
    abiopetaja.url = "github:gekoke/abiopetaja";
    agenix-shell.url = "github:aciceri/agenix-shell";
    agenix.url = "github:ryantm/agenix";
    dank-material-shell.url = "github:AvengeMedia/DankMaterialShell";
    dgop.url = "github:AvengeMedia/dgop";
    disko.url = "github:nix-community/disko";
    emacs-lsp-booster.url = "github:slotThe/emacs-lsp-booster-flake";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    niri-flake.url = "github:sodiboo/niri-flake";
    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixpkgs-emacs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-for-opentofu.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    noshell.url = "github:viperML/noshell";
    nur.url = "github:nix-community/NUR";
    proxytunnel.url = "github:proxytunnel/proxytunnel";
    systems.url = "github:nix-systems/default-linux";
    # TODO: move `inputs.website` and `inputs.resume` in-tree?
    website.url = "github:gekoke/website";
    # keep-sorted end
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit (self) lib;
      inherit (inputs.flake-parts.lib) mkFlake;
    in
    mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        ./checks.nix
        ./dev-shells.nix
        ./formatter.nix
      ];

      flake = {
        lib = import ./lib { inherit inputs; };

        nixosModules = {
          # keep-sorted start block=yes
          "constants" = lib.mkModule ./modules/nixos/constants;
          "elementary.user" = lib.mkModule ./modules/nixos/user;
          "programs.emacs" = lib.mkModule ./modules/nixos/programs/emacs;
          "roles.graphical" = lib.mkModule ./modules/nixos/roles/graphical;
          "roles.work" = lib.mkModule ./modules/nixos/roles/work;
          "roles.workstation" = lib.mkModule ./modules/nixos/roles/workstation;
          "roles.wsl" = lib.mkModule ./modules/nixos/roles/wsl;
          # keep-sorted end
        };

        homeModules = {
          # keep-sorted start block=yes
          "cliTools" = lib.mkModule ./modules/home/cli-tools;
          "identities.geko" = lib.mkModule ./modules/home/identities/geko;
          "programs.direnv" = lib.mkModule ./modules/home/programs/direnv;
          "programs.git" = lib.mkModule ./modules/home/programs/git;
          "programs.gpg" = lib.mkModule ./modules/home/programs/gpg;
          "programs.nh" = lib.mkModule ./modules/home/programs/nh;
          "programs.noshell" = lib.mkModule ./modules/home/programs/noshell;
          "programs.zsh" = lib.mkModule ./modules/home/programs/zsh;
          "roles.work" = lib.mkModule ./modules/home/roles/work;
          # keep-sorted end
        };

        nixosConfigurations =
          let
            specialArgs = { inherit inputs; };

            commonModules = [
              {
                nix.settings = nixConfig;

                nixpkgs.config.allowUnfree = true;
              }
              (lib.mkModule ./modules/nixos/programs/firefox)
              ./modules/nixos/desktop/niri
              ./modules/nixos/home
              ./modules/nixos/nix
              ./modules/nixos/programs/kitty
              ./modules/nixos/programs/ssh
              ./modules/nixos/secrets
              ./modules/nixos/services/linkace
              ./modules/nixos/services/opengist
              ./modules/nixos/user/shell/nushell
              inputs.self.nixosModules."elementary.user"
              inputs.self.nixosModules."programs.emacs"
            ];
          in
          {
            carbon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = lib.mkDefault "carbon"; }
                (lib.mkModule ./systems/x86_64-linux/carbon)
              ];
              inherit specialArgs;
            };
            hydrogen = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = lib.mkDefault "hydrogen"; }
                (lib.mkModule ./systems/x86_64-linux/hydrogen)
              ];
              inherit specialArgs;
            };
            neon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = lib.mkDefault "neon"; }
                (lib.mkModule ./systems/x86_64-linux/neon)
              ];
              inherit specialArgs;
            };
            nitrogen = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = lib.mkDefault "nitrogen"; }
                (lib.mkModule ./systems/x86_64-linux/nitrogen)
              ];
              inherit specialArgs;
            };
            silicon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = lib.mkDefault "silicon"; }
                (lib.mkModule ./systems/x86_64-linux/silicon)
              ];
              inherit specialArgs;
            };
          };
      };

      perSystem =
        { pkgs, system, ... }:
        let
          pkgs-emacs = import inputs.nixpkgs-emacs {
            inherit system;
            overlays = [ (import ./packages/elementary-emacs/overlay.nix) ];
            config.allowUnfree = true;
          };
          emacs = pkgs-emacs.emacs30-pgtk;
          emacsPackages = pkgs-emacs.emacsPackagesFor emacs;
          mkElementaryEmacsPackage =
            path: extraArgs:
            pkgs-emacs.callPackage path (
              {
                inherit emacsPackages;
              }
              // elementaryEmacsPackages
              // extraArgs
            );
          elementaryEmacsPackages = {
            # keep-sorted start block=yes
            elementary-emacs-completion = mkElementaryEmacsPackage ./packages/elementary-emacs-completion { };
            elementary-emacs-csharp = mkElementaryEmacsPackage ./packages/elementary-emacs-csharp { };
            elementary-emacs-editor = mkElementaryEmacsPackage ./packages/elementary-emacs-editor { };
            elementary-emacs-files = mkElementaryEmacsPackage ./packages/elementary-emacs-files { };
            elementary-emacs-java = mkElementaryEmacsPackage ./packages/elementary-emacs-java { };
            elementary-emacs-keys = mkElementaryEmacsPackage ./packages/elementary-emacs-keys { };
            elementary-emacs-lsp = mkElementaryEmacsPackage ./packages/elementary-emacs-lsp { };
            elementary-emacs-markdown = mkElementaryEmacsPackage ./packages/elementary-emacs-markdown { };
            elementary-emacs-nix = mkElementaryEmacsPackage ./packages/elementary-emacs-nix { };
            elementary-emacs-prelude = mkElementaryEmacsPackage ./packages/elementary-emacs-prelude { };
            elementary-emacs-python = mkElementaryEmacsPackage ./packages/elementary-emacs-python { };
            elementary-emacs-rust = mkElementaryEmacsPackage ./packages/elementary-emacs-rust { };
            elementary-emacs-terminal = mkElementaryEmacsPackage ./packages/elementary-emacs-terminal { };
            elementary-emacs-themes = mkElementaryEmacsPackage ./packages/elementary-emacs-themes {
              miasma-theme = emacsPackages.callPackage ./packages/miasma-theme { };
            };
            elementary-emacs-vc = mkElementaryEmacsPackage ./packages/elementary-emacs-vc { };
            elementary-emacs-visual = mkElementaryEmacsPackage ./packages/elementary-emacs-visual { };
            elementary-emacs-web = mkElementaryEmacsPackage ./packages/elementary-emacs-web { };
            elementary-emacs-workspaces = mkElementaryEmacsPackage ./packages/elementary-emacs-workspaces { };
            # keep-sorted end
          };
          elementary-emacs = pkgs-emacs.callPackage ./packages/elementary-emacs (
            elementaryEmacsPackages
            // {
              inherit emacs emacsPackages;
            }
          );
        in
        {
          packages = {
            # keep-sorted start block=yes
            connections = pkgs.callPackage ./packages/connections { };
            inherit elementary-emacs;
            lombok-jar = pkgs.callPackage ./packages/lombok-jar { };
            miasma-theme = pkgs-emacs.callPackage ./packages/miasma-theme { };
            scramsha256 = pkgs.callPackage ./packages/scramsha256 { };
            wallpapers = pkgs.callPackage ./packages/wallpapers { };
            wsl-notify-send = pkgs.callPackage ./packages/wsl-notify-send { };
            # keep-sorted end
          }
          // elementaryEmacsPackages;
        };
    };
}
