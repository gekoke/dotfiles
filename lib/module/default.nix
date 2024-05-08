{ lib, ... }:

with lib;
{
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  enabled = {
    enable = true;
  };
  disabled = {
    enable = false;
  };
}
