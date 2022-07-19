{ lib, inputs, nixpkgs, home-manager, user, location, ... }:

let
  # TODO: Do I need this here?
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  luna = lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = { inherit inputs user location; };
    modules =
      [
        ./luna
        ./base-configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user; };
          home-manager.users.${user} = {
            imports = [(import ./home.nix)] ++ [(import ./luna/home.nix)];
          };
        }
      ];
  };

  orion = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    modules = [
      ./orion/default.nix
      {
        home = {
          homeDirectory = "/home/${user}";
          username = "${user}";
          stateVersion = "22.05";
        };
      }
    ];
  };
}

