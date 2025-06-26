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
          packages = [ pkgs.opentofu ];
        };

        playwright =
          let
            pkgs = inputs.nixpkgs-for-playwright.legacyPackages.${system};
          in
          pkgs.mkShellNoCC {
            nativeBuildInputs = [
              pkgs.playwright-driver.browsers
            ];

            shellHook = ''
              export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
              export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
            '';
          };
      };
    };
}
