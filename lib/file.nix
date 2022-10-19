{ lib }:
let
  inherit (builtins) pathExists readFile;
in {
  readFileOrNil = path: if pathExists path then readFile path else "";
}
