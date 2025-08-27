{ inputs, ... }:
{
  perSystem =
    {
      config,
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          packages = [
            inputs'.agenix.packages.agenix
            pkgs.deadnix
            pkgs.opentofu
            pkgs.tflint
          ];

          shellHook = config.pre-commit.installationScript;
        };

        deploy = pkgs.mkShellNoCC {
          packages =
            let
              pkgs = inputs.nixpkgs-for-opentofu.legacyPackages.${system};
              openTofuWithPlugins = pkgs.opentofu.withPlugins (p: [
                p.aws
                p.cloudflare
                p.hcloud
                p.neon

                # nixos-anwyhere dependencies
                p.external
                p.null
              ]);
            in
            [ openTofuWithPlugins ];
        };
      };
    };
}
