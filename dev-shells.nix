_: {
  perSystem =
    { config, pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          name = "elementary-shell";

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
          name = "deploy";
          packages = [ pkgs.opentofu ];
        };
      };
    };
}
