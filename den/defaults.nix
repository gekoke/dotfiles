{ den, ... }:
{
  den.schema.user.classes = [ "homeManager" ];

  den.default.homeManager.xdg.enable = true;

  den.schema.host.includes = [ den.batteries.mutual-provider ];

  den.default = {
    includes = [
      den.batteries.hostname
      den.batteries.define-user
    ];

    nixos.nix.settings = {
      inherit ((import ../flake.nix).nixConfig) extra-substituters extra-trusted-public-keys;
    };
  };

  den.schema.hm-host.includes = [
    {
      nixos.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
  ];

}
