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
    # FIXME: point to `nixpkgs-unstable` after `94d0b41dd97f8e3c9331cf8b2750d582a89475ee` is merged
    nixpkgs.url = "github:nixos/nixpkgs?rev=94d0b41dd97f8e3c9331cf8b2750d582a89475ee";

    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";

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

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

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

    glucose.url = "github:gekoke/glucose";
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
          inputs.emacs-overlay.overlays.default
          inputs.nur.overlays.default
        ];

        channels-config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "dotnet-sdk-6.0.428"
          ];
        };
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
