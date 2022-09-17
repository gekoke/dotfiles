{
  description = "My Nix system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
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

    nixosConfigurations = {
      luna = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {inherit inputs user location;};
        modules = [
          ./hosts/luna
          ./hosts/base-configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {inherit user inputs;};
            home-manager.users.${user} = {
              imports = [
                ./hosts/home.nix
                ./hosts/luna/home.nix
              ];
            };
          }
        ];
      };
    };

    orion = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      extraSpecialArgs = {inherit inputs;};
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
