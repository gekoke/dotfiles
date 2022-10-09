{
  description = "My Nix system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = github:nix-community/NUR;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs @ { self
             , nixpkgs
             , nur
             , home-manager
             , ...
             }:
    let
      user = "geko";
      location = "$HOME/.setup";
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      mylib = import ./lib { lib = nixpkgs.lib; };
      prefs = import ./preferences.nix { lib = nixpkgs.lib; mylib = mylib; };
    in {
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;

      shells = import ./shells { pkgs = pkgs; };

      nixosConfigurations = {
        luna = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs user location mylib; };
          modules = [
            ./hosts/luna
            ./hosts/base-configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs user location; };
              home-manager.users.${user} = {
                imports = [
                  nur.nixosModules.nur
                  prefs
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
