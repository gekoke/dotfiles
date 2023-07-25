{ lib, ... }:
with lib;
{
  readFiles = files:
    foldl' (txt: file: txt + (builtins.readFile file)) "" files;
}
