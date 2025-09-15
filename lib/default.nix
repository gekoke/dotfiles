{
  lib,
  ...
}:
lib.extend (
  _final: prev:
  let
    inherit (prev) mkOption;
  in
  {
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
    };
  }
)
