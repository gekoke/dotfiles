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
            nixfmt-rfc-style.enable = true;
            deadnix = {
              enable = true;
              settings.edit = true;
            };
            statix = {
              enable = true;
              settings.ignore = [ "tofu/.terraform/**" ];
            };
            gitleaks = {
              enable = true;
              name = "gitleaks";
              entry = "${lib.getExe pkgs.gitleaks} protect --verbose --redact --staged";
              pass_filenames = false;
            };
          };
        };
      };
    };
}
