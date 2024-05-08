{ inputs, ... }:
{
  imports = [
    inputs.nix-pre-commit-hooks.flakeModule
  ];

  perSystem = { pkgs, ... }: {
    pre-commit = {
      check.enable = true;

      settings = {
        excludes = [ "systems/.*/.*/hardware-configuration.nix" ];
        hooks = {
          deadnix.enable = true;
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
          shellcheck.enable = true;
          statix.enable = true;
          gitleaks = {
            enable = true;
            name = "gitleaks";
            entry = "${pkgs.gitleaks}/bin/gitleaks protect --verbose --redact --staged";
            pass_filenames = false;
          };
        };
        settings.deadnix.edit = true;
      };
    };
  };
}
