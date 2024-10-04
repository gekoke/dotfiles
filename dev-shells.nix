_: {
  perSystem =
    { config, pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          name = "elementary-shell";

          nativeBuildInputs = [ pkgs.deadnix ];

          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    };
}
