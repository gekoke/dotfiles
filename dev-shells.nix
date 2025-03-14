_: {
  perSystem =
    { config, pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          packages = [
            pkgs.deadnix
            pkgs.opentofu
            pkgs.tflint
          ];

          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        deploy = pkgs.mkShellNoCC {
          packages = [ pkgs.opentofu ];
        };
      };
    };
}
