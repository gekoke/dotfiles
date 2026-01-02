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
            ".direnv/.*"
            "systems/.*/.*/hardware-configuration.nix"
          ];
          hooks = {
            # TODO: use treefmt for these instead, and run treefmt with git-hooks.nix
            # keep-sorted start block=yes
            actionlint.enable = true;
            deadnix = {
              enable = true;
              settings.edit = true;
            };
            gitleaks = {
              enable = true;
              name = "gitleaks";
              entry = "${lib.getExe pkgs.gitleaks} protect --verbose --redact --staged";
              pass_filenames = false;
            };
            keep-sorted.enable = true;
            nixfmt-rfc-style.enable = true;
            prettier.enable = true;
            statix = {
              enable = true;
              settings.ignore = [ "tofu/.terraform/**" ];
            };
            terraform-format.enable = true;
            tflint = {
              enable = true;
              name = "tflint";
              entry = "${lib.getExe pkgs.tflint} --chdir ./tofu --disable-rule=terraform_required_providers --disable-rule=terraform_required_version";
              pass_filenames = false;
            };
            tofu-fmt = {
              enable = true;
              name = "tofu-fmt";
              entry = "${lib.getExe pkgs.opentofu} fmt ./tofu";
              pass_filenames = false;
            };
            # keep-sorted end
          };
        };
      };
    };
}
