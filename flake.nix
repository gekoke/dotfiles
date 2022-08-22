{
  description = "My Nix system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nix-doom-emacs,
    ...
  }: let
    user = "geko";
    location = "$HOME/.setup";
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager nix-doom-emacs user location;
      }
    );
  };
}
