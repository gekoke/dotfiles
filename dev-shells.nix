_: {
  perSystem =
    {
      config,
      inputs',
      pkgs,
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
          packages = [ pkgs.opentofu ];
        };
      };
    };
}
