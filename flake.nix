{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";
    # FIXME: can be removed after https://github.com/gytis-ivaskevicius/flake-utils-plus/pull/134 is merged
    flake-utils-plus-fix.url = "github:ravensiris/flake-utils-plus/ravensiris/fix-devshell-legacy-packages";
    snowfall-lib.inputs.flake-utils-plus.follows = "flake-utils-plus-fix";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    stylix.url = "github:danth/stylix";

    base16.url = "github:SenchoPens/base16.nix";

    pinned-swww.url = "github:NixOS/nixpkgs/8bf3e834daedadc6d0f4172616b2bdede1109c48";
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
      };
    in
      lib.mkFlake {
        package-namespace = "plusultra";

        systems.modules = with inputs; [
          nur.nixosModules.nur
          agenix.nixosModules.default
        ];

        overlays = with inputs; [
          emacs-overlay.overlays.default
          hyprland.overlays.hyprland-extras
        ];

        channels-config = {
          allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
            "nvidia-x11"
            "nvidia-settings"
          ];
          permittedInsecurePackages = [
            "xpdf-4.04"
          ];
        };

        formatter.x86_64-linux = (import inputs.nixpkgs { system = "x86_64-linux"; }).pkgs.nixpkgs-fmt;
      };
}
