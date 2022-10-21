{ lib }:
let
  callLib = file: import file { lib = lib; };
in
{
  core = callLib ./core.nix;
  color = callLib ./color.nix;
  file = callLib ./file.nix;
}
