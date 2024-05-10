{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    rofi-collection.url = "github:adi1090x/rofi";
    rofi-collection.flake = false;

    ranger-devicons.url = "github:alexanderjeurissen/ranger_devicons";
    ranger-devicons.flake = false;

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    pinned-swww.url = "github:NixOS/nixpkgs/8bf3e834daedadc6d0f4172616b2bdede1109c48";
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
          { nix.settings = import ./settings.nix; }
        ];

        overlays = [
          inputs.emacs-overlay.overlays.default
          inputs.nur.overlay
        ];

        channels-config.allowUnfree = true;
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
