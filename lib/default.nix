{ lib }:
let
  callLib = file: import file { lib = lib; };
in
{
  color = callLib ./color.nix;
}
