{ lib }:
let
  inherit (lib) mkIf mkMerge;
in
{
  mkMergeIf = cond: elems: mkIf cond (mkMerge elems);
}
