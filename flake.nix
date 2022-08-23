{
  description = "My Nix system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    emacs-overlay,
    ...
  }: let
    user = "geko";
    location = "$HOME/.setup";
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  in {
    formatter.x86_64-linux = pkgs.alejandra;

    luna = pkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs user location; };
      modules = [
        ./hosts/luna
        ./hosts/base-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user; };
          home-manager.users.${user} = {
            imports = [
              ./home.nix
              ./luna/home.nix
            ];
          };
        }
      ];
    };

    orion = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./hosts/orion
        {
          home = {
            homeDirectory = "/home/${user}";
            username = "${user}";
            stateVersion = "22.05";
          };
        }
      ];
    };
  };
}
