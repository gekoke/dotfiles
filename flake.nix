{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";
    # FIXME: can be removed after https://github.com/gytis-ivaskevicius/flake-utils-plus/pull/134 is merged
    flake-utils-plus-fix.url = "github:ravensiris/flake-utils-plus/ravensiris/fix-devshell-legacy-packages";
    snowfall-lib.inputs.flake-utils-plus.follows = "flake-utils-plus-fix";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    wrapper-manager.url = "github:viperML/wrapper-manager";
    wrapper-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    stylix.url = "github:danth/stylix";

    base16.url = "github:SenchoPens/base16.nix";

    rofi-collection.url = "github:adi1090x/rofi";
    rofi-collection.flake = false;

    ranger-devicons.url = "github:alexanderjeurissen/ranger_devicons";
    ranger-devicons.flake = false;

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    nwg-displays-with-desktop-file.url = "github:gekoke/nixpkgs/gekoke/nwg-displays";

    pinned-swww.url = "github:NixOS/nixpkgs/8bf3e834daedadc6d0f4172616b2bdede1109c48";
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall.namespace = "elementary";
      };

      eachSystem' = lib.genAttrs (import inputs.systems);
      eachSystem = fn:
        eachSystem' (system:
          let
            pkgs = import inputs.nixpkgs { inherit system; };
          in
          fn system pkgs);
    in
    lib.recursiveUpdate
      (lib.mkFlake
        {
          systems.modules.nixos = [
            inputs.agenix.nixosModules.default
            {
              nix.settings = {
                substituters = [
                  "https://nix-community.cachix.org"
                  "https://hyprland.cachix.org"
                ];
                trusted-public-keys = [
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                ];
              };
            }
          ];

          overlays = [
            inputs.emacs-overlay.overlays.default
            inputs.nur.overlay
          ];

          channels-config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "xpdf-4.04"
            ];
          };

          formatter = eachSystem (_: pkgs: pkgs.nixpkgs-fmt);
        })
      (inputs.flake-parts.lib.mkFlake { inherit inputs; }
        {
          systems = import inputs.systems;
          imports = [
            ./checks.nix
            ./dev-shells.nix
          ];
        });
}
