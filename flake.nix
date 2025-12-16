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
    nixpkgs-for-opentofu.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    noshell.url = "github:viperML/noshell";
    nur.url = "github:nix-community/NUR";
    systems.url = "github:nix-systems/default";
    # TODO: move `inputs.website` and `inputs.resume` in-tree?
    website.url = "github:gekoke/website";
    # keep-sorted end
    # keep-sorted start
    dank-material-shell.inputs.dgop.follows = "dgop";
    dank-material-shell.inputs.nixpkgs.follows = "nixpkgs";
    dgop.inputs.nixpkgs.follows = "nixpkgs";
    emacs-lsp-booster.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";
    noshell.inputs.nixpkgs.follows = "nixpkgs";
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
          "programs.git" = lib.mkModule ./modules/home/programs/git;
          "programs.gpg" = lib.mkModule ./modules/home/programs/gpg;
          "programs.nh" = lib.mkModule ./modules/home/programs/nh;
          "programs.noshell" = lib.mkModule ./modules/home/programs/noshell;
          "programs.zsh" = lib.mkModule ./modules/home/programs/zsh;
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
              ./modules/nixos/hardware/audio
              ./modules/nixos/hardware/networking
              ./modules/nixos/hardware/nvidia
              ./modules/nixos/home
              ./modules/nixos/nix
              ./modules/nixos/programs/direnv
              ./modules/nixos/programs/kitty
              ./modules/nixos/programs/ssh
              ./modules/nixos/secrets
              ./modules/nixos/services/linkace
              ./modules/nixos/services/tzupdate
              ./modules/nixos/services/udiskie
              ./modules/nixos/suites/desktop
              ./modules/nixos/system/boot
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
