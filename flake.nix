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

    nixpkgs-for-emacs-packages.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-for-opentofu.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-for-playwright.url = "github:nixos/nixpkgs?ref=df6ad2118bd2d7855a42c11bdf02e84f96924715";

    nixpkgs-for-pkgs-azure-cli.url = "github:nixos/nixpkgs?ref=54aac082a4d9bb5bbc5c4e899603abfb76a3f6d6";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    agenix.url = "github:ryantm/agenix";

    agenix-shell.url = "github:aciceri/agenix-shell";

    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland-contrib.url = "github:hyprwm/contrib";

    stylix.url = "github:danth/stylix";

    rofi-collection.url = "github:adi1090x/rofi";
    rofi-collection.flake = false;

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    emacs-lsp-booster.url = "github:slotThe/emacs-lsp-booster-flake";
    emacs-lsp-booster.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
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
        nixosConfigurations =
          let
            allowedUnfreePackages = [
              "discord"
              "nvidia-settings"
              "nvidia-x11"
              "steam-unwrapped"
              "terraform"
            ];

            dependencies = inputs // {
              elementaryPackages = inputs.self.packages;
              nurPackages = inputs.nur.legacyPackages;
            };
            wire = path: importApply path dependencies;

            specialArgs = { inherit inputs; };

            commonModules = [
              {
                nix.settings = nixConfig;

                nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowedUnfreePackages;

                home-manager.sharedModules = [
                  ./modules/home/accounts/geko/default.nix
                  ./modules/home/cli-tools/default.nix
                  ./modules/home/programs/git/default.nix
                  ./modules/home/programs/gpg/default.nix
                ];
              }
              (wire ./modules/nixos/programs/emacs)
              (wire ./modules/nixos/programs/firefox)
              (wire ./modules/nixos/stylix/stylesheets/main)
              ./modules/nixos/desktop/addons/avizo
              ./modules/nixos/desktop/addons/clipboard
              ./modules/nixos/desktop/addons/cursor
              ./modules/nixos/desktop/addons/dunst
              ./modules/nixos/desktop/addons/keyring
              ./modules/nixos/desktop/addons/rofi
              ./modules/nixos/desktop/addons/screenshot
              ./modules/nixos/desktop/addons/swaylock
              ./modules/nixos/desktop/addons/unclutter
              ./modules/nixos/desktop/addons/waybar
              ./modules/nixos/desktop/addons/wlogout
              ./modules/nixos/desktop/hyprland
              ./modules/nixos/hardware/audio
              ./modules/nixos/hardware/filesystems
              ./modules/nixos/hardware/networking
              ./modules/nixos/hardware/nvidia
              ./modules/nixos/home
              ./modules/nixos/nix
              ./modules/nixos/programs/alacritty
              ./modules/nixos/programs/direnv
              ./modules/nixos/programs/kitty
              ./modules/nixos/programs/nwg-displays
              ./modules/nixos/programs/spotify
              ./modules/nixos/programs/ssh
              ./modules/nixos/roles/workstation
              ./modules/nixos/secrets
              ./modules/nixos/security/sudo
              ./modules/nixos/services/tzupdate
              ./modules/nixos/services/udiskie
              ./modules/nixos/stylix
              ./modules/nixos/suites/desktop
              ./modules/nixos/system/boot
              ./modules/nixos/system/keyboard
              ./modules/nixos/user
              ./modules/nixos/user/shell/nushell
              ./modules/nixos/user/shell/zsh
              ./modules/nixos/virtualisation/docker
              ./modules/nixos/virtualisation/kvm
            ];
          in
          {
            carbon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [ ./systems/x86_64-linux/carbon ];
              inherit specialArgs;
            };
            hydrogen = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [ ./systems/x86_64-linux/hydrogen ];
              inherit specialArgs;
            };
            neon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [ ./systems/x86_64-linux/neon ];
              inherit specialArgs;
            };
            silicon = lib.nixosSystem {
              system = "x86_64-linux";
              modules = commonModules ++ [ ./systems/x86_64-linux/silicon ];
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
