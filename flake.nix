rec {
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://gekoke-dotfiles.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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
    inputs:
    let
      lib = import ./lib { inherit (inputs.nixpkgs) lib; };
      inherit (inputs.flake-parts.lib) mkFlake importApply;
    in
    mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        ./checks.nix
        ./dev-shells.nix
        ./formatter.nix
      ];

      flake = {
        lib = import ./lib { inherit (inputs.nixpkgs) lib; };

        nixosModules =
          let
            mkModule =
              modulePath:
              (
                # NOTE: home-manager *requires* modules to specify named arguments or it will not
                # pass values in. For this reason we must specify things like `pkgs` as a named attribute.
                # Thanks Jake Hamilton!
                # https://github.com/snowfallorg/lib/blob/02d941739f98a09e81f3d2d9b3ab08918958beac/snowfall-lib/module/default.nix#L42
                moduleArgs@{ pkgs, ... }:
                let
                  dependencies = {
                    inherit inputs;
                    inherit (inputs) self;
                  };
                  module = import modulePath;
                  moduleArgsInjected = moduleArgs // { inherit pkgs; } // dependencies;
                in
                module moduleArgsInjected
              );
          in
          {
            "programs.emacs" = mkModule ./modules/nixos/programs/emacs;
          };

        nixosConfigurations =
          let
            dependencies = inputs // {
              inherit (inputs) self;
              elementaryPackages = inputs.self.packages;
              nurPackages = inputs.nur.legacyPackages;
            };
            wire = path: importApply path dependencies;

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
              inputs.self.nixosModules."programs.emacs"
              (wire ./modules/nixos/programs/firefox)
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
              ./modules/nixos/roles/workstation
              ./modules/nixos/secrets
              ./modules/nixos/security/sudo
              ./modules/nixos/services/linkace
              ./modules/nixos/services/tzupdate
              ./modules/nixos/services/udiskie
              ./modules/nixos/suites/desktop
              ./modules/nixos/system/boot
              ./modules/nixos/user
              ./modules/nixos/user/shell/nushell
              ./modules/nixos/user/shell/zsh
              ./modules/nixos/virtualisation/docker
            ];
          in
          {
            carbon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = "carbon"; }
                ./systems/x86_64-linux/carbon
              ];
              inherit specialArgs;
            };
            hydrogen = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = "hydrogen"; }
                ./systems/x86_64-linux/hydrogen
              ];
              inherit specialArgs;
            };
            neon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = "neon"; }
                (wire ./systems/x86_64-linux/neon)
              ];
              inherit specialArgs;
            };
            silicon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [
                { networking.hostName = "silicon"; }
                ./systems/x86_64-linux/silicon
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
