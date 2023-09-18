{ lib, ... }:
with lib;
{
  readFiles =
    foldl' (txt: file: txt + (builtins.readFile file)) "";
}
