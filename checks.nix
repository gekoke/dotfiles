{ inputs, ... }:
{
  imports = [ inputs.nix-pre-commit-hooks.flakeModule ];

  perSystem =
    { lib, pkgs, ... }:
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
            tofu-fmt = {
              enable = true;
              name = "tofu-fmt";
              entry = "${lib.getExe pkgs.opentofu} fmt ./tofu";
              pass_filenames = false;
            };
            tflint = {
              enable = true;
              name = "tflint";
              entry = "${lib.getExe pkgs.tflint} --chdir ./tofu --disable-rule=terraform_required_providers --disable-rule=terraform_required_version";
              pass_filenames = false;
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
