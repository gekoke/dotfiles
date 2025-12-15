{
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;
in
lib.extend (
  _final: prev:
  let
    inherit (prev) mkOption;
  in
  rec {
    elementary = rec {
      mkOpt =
        type: default: description:
        mkOption { inherit type default description; };

      enabled = {
        enable = true;
      };

      disabled = {
        enable = false;
      };

      pow =
        base: exponent:
        assert builtins.isInt base;
        assert builtins.isInt exponent;
        assert exponent >= 0;
        if exponent == 0 then 1 else base * pow base (exponent - 1);

      # Avoid overflow triggering an evaluation error
      I64_MAX = (pow 2 62) - 1 + (pow 2 62);

      cat =
        let
          inherit (builtins) readFile;
          inherit (lib) pipe concatLines;
        in
        paths:
        pipe paths [
          (map readFile)
          concatLines
        ];
    };

    # Gradual migration
    inherit (elementary) I64_MAX;

    mkModule =
      modulePath:
      (
        # NOTE: home-manager *requires* modules to specify named arguments or it will not
        # pass values in. For this reason we must specify things like `pkgs` as a named attribute.
        # Thanks Jake Hamilton!
        # https://github.com/snowfallorg/lib/blob/02d941739f98a09e81f3d2d9b3ab08918958beac/snowfall-lib/module/default.nix#L42
        moduleArgs@{ pkgs, ... }:
        let
          dependencies = {
            inherit inputs;
            inherit (inputs) self;
          };
          moduleArgsInjected = moduleArgs // { inherit pkgs; } // dependencies;
        in
        # `key` is needed for deduplication
        # See https://github.com/NixOS/nixpkgs/issues/340361
        (import modulePath moduleArgsInjected)
        // {
          key = "gekoke/dotfiles/" + "49d77c99-18c4-4138-8d17-466e36ae85b2" + modulePath;
        }
      );
  }
)
