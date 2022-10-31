{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.dev.nix;
in
{
  options.modules.dev.nix = {
    enable = mkEnableOption "Nix dev support";
  };
}
