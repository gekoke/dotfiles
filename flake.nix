rec {
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-master.url = "github:nixos/nixpkgs";

    nixpkgs-for-opentofu.url = "github:gekoke/nixpkgs/terraform-provider-neon-0.9.0";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    agenix.url = "github:ryantm/agenix";

    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland-contrib.url = "github:hyprwm/contrib";

    stylix.url = "github:danth/stylix";

    rofi-collection.url = "github:adi1090x/rofi";
    rofi-collection.flake = false;

    ranger-devicons.url = "github:alexanderjeurissen/ranger_devicons";
    ranger-devicons.flake = false;

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    emacs-lsp-booster.url = "github:slotThe/emacs-lsp-booster-flake";
    emacs-lsp-booster.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";

    nixpkgs-for-playwright.url = "github:nixos/nixpkgs";
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall.namespace = "elementary";
      };
    in
    lib.recursiveUpdate
      (lib.mkFlake {
        systems.modules.nixos = [
          inputs.agenix.nixosModules.default
          { nix.settings = nixConfig; }
        ];

        overlays = [
          inputs.nur.overlays.default
        ];

        channels-config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "discord"
            "nvidia-settings"
            "nvidia-x11"
            "steam-unwrapped"
          ];
      })
      (
        inputs.flake-parts.lib.mkFlake { inherit inputs; } {
          systems = import inputs.systems;
          imports = [
            ./checks.nix
            ./dev-shells.nix
            ./formatter.nix
          ];
        }
      );
}
