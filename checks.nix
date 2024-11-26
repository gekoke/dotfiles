{ inputs, ... }:
{
  imports = [ inputs.nix-pre-commit-hooks.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      pre-commit = {
        check.enable = true;

        settings = {
          excludes = [
            "systems/.*/.*/hardware-configuration.nix"
            ".direnv/.*"
          ];
          hooks = {
            deadnix = {
              enable = true;
              settings = {
                edit = true;
              };
            };
            nixfmt-rfc-style.enable = true;
            shellcheck.enable = true;
            statix.enable = true;
            gitleaks = {
              enable = true;
              name = "gitleaks";
              entry = "${pkgs.gitleaks}/bin/gitleaks protect --verbose --redact --staged";
              pass_filenames = false;
            };
          };
        };
      };
    };
}
