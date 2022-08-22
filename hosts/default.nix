{
  lib,
  inputs,
  nixpkgs,
  home-manager,
  nix-doom-emacs,
  user,
  location,
  ...
}: let
  # TODO: Do I need this here?
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in {
  luna = lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {inherit inputs user location;};
    modules = [
      ./luna
      ./base-configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit user;};
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./luna/home.nix
            nix-doom-emacs.hmModule
          ];
        };
      }
    ];
  };

  orion = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    modules = [
      nix-doom-emacs.hmModule
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
