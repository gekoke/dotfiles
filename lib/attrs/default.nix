{ ... }:
{
  mapAttrValues = f: attrs:
    builtins.mapAttrs (_: value: f value) attrs;
}
