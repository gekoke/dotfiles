{ lib, ... }:
with builtins;
with lib;
{
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);
}
