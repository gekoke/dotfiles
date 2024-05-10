{ lib, ... }:
let
  inherit (lib) foldl';
in
{
  readFiles = foldl' (txt: file: txt + (builtins.readFile file)) "";
}
