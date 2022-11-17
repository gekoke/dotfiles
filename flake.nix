{
  description = "My Nix system configurations";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nur.url = github:nix-community/NUR;

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
    in
    {
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;

      nixosConfigurations = {
        luna = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs user location mylib; };
          modules = [
            ./hosts/luna/default.nix
            ./hosts/luna/hardware-configuration.nix
            ./modules/sys
            ./modules/options.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs user location nixpkgs mylib; };
              home-manager.users."geko" = {
                imports = [
                  nur.nixosModules.nur
                  ./hosts/luna/home.nix
                  ./modules/hm
                  ./modules/options.nix
                  {
                    modules.graphical.enable = true;
                  }
                ];
              };
            }
            {
              modules.graphical.enable = true;
            }
          ];
        };

        sol = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs user location mylib; };
          modules = [
            ./hosts/sol/default.nix
            ./hosts/sol/hardware-configuration.nix
            ./modules/sys
            ./modules/options.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs user location nixpkgs mylib; };
              home-manager.users."geko" = {
                imports = [
                  nur.nixosModules.nur
                  ./hosts/sol/home.nix
                  ./modules/hm
                  ./modules/options.nix
                  {
                    modules.graphical.enable = true;
                  }
                ];
              };
            }
            {
              modules.graphical.enable = true;
            }
          ];
        };
      };
    };
}
