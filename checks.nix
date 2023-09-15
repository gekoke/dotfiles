{ inputs, ... }:
{
  imports = [
    inputs.nix-pre-commit-hooks.flakeModule
  ];

  perSystem = { ... }: {
    pre-commit = {
      check.enable = true;

      settings = {
        excludes = [ "systems/.*/.*/hardware-configuration.nix" ];
        hooks = {
          deadnix.enable = true;
          nixpkgs-fmt.enable = true;
          shellcheck.enable = true;
        };
        settings.deadnix.edit = true;
      };
    };
  };
}
