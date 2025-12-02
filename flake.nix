rec {
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://gekoke-dotfiles.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "gekoke-dotfiles.cachix.org-1:mED8HYGwRLMcDvi54a/Qxl5LshQtOXRt3rlXHw4GkDw="
    ];
  };

  inputs = {
    systems.url = "github:nix-systems/default";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-for-opentofu.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    agenix.url = "github:ryantm/agenix";

    agenix-shell.url = "github:aciceri/agenix-shell";

    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    noshell.url = "github:viperML/noshell";
    noshell.inputs.nixpkgs.follows = "nixpkgs";

    niri-flake.url = "github:sodiboo/niri-flake";

    dgop.url = "github:AvengeMedia/dgop";
    dgop.inputs.nixpkgs.follows = "nixpkgs";

    dank-material-shell.url = "github:AvengeMedia/DankMaterialShell";
    dank-material-shell.inputs.nixpkgs.follows = "nixpkgs";
    dank-material-shell.inputs.dgop.follows = "dgop";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    emacs-lsp-booster.url = "github:slotThe/emacs-lsp-booster-flake";
    emacs-lsp-booster.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";

    website.url = "github:gekoke/website";
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
          "programs.emacs" = lib.mkModule ./modules/nixos/programs/emacs;
          "elementary.user" = lib.mkModule ./modules/nixos/user;
        };

        homeModules = {
          "programs.noshell" = lib.mkModule ./modules/home/programs/noshell;
          "programs.zsh" = lib.mkModule ./modules/home/programs/zsh;
        };

        nixosConfigurations =
          let
            specialArgs = { inherit inputs; };

            commonModules = [
              {
                nix.settings = nixConfig;

                nixpkgs.config.allowUnfree = true;

                home-manager.sharedModules = [
                  ./modules/home/accounts/geko/default.nix
                  ./modules/home/cli-tools/default.nix
                  ./modules/home/programs/git/default.nix
                  ./modules/home/programs/gpg/default.nix
                ];
              }
              (lib.mkModule ./modules/nixos/programs/firefox)
              (lib.mkModule ./modules/nixos/roles/workstation)
              ./modules/nixos/desktop/niri
              ./modules/nixos/hardware/audio
              ./modules/nixos/hardware/filesystems
              ./modules/nixos/hardware/networking
              ./modules/nixos/hardware/nvidia
              ./modules/nixos/home
              ./modules/nixos/nix
              ./modules/nixos/programs/direnv
              ./modules/nixos/programs/kitty
              ./modules/nixos/programs/ssh
              ./modules/nixos/secrets
              ./modules/nixos/security/sudo
              ./modules/nixos/services/linkace
              ./modules/nixos/services/tzupdate
              ./modules/nixos/services/udiskie
              ./modules/nixos/suites/desktop
              ./modules/nixos/system/boot
              ./modules/nixos/user/shell/nushell
              ./modules/nixos/virtualisation/docker
              inputs.self.nixosModules."elementary.user"
              inputs.self.nixosModules."programs.emacs"
            ];
          in
          {
            carbon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = lib.mkDefault "carbon"; }
                ./systems/x86_64-linux/carbon
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
        { pkgs, ... }:
        {
          packages = {
            lombok-jar = pkgs.callPackage ./packages/lombok-jar { };
            miasma-theme = pkgs.callPackage ./packages/miasma-theme { };
            typst-ts-mode = pkgs.callPackage ./packages/typst-ts-mode { };
            wallpapers = pkgs.callPackage ./packages/wallpapers { };
          };
        };
    };
}
