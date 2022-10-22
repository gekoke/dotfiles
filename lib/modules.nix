{ self, lib }:
with builtins;
with lib;
let
  inherit (self.attrs) mapFilterAttrs;
in
{
  mkMergeIf = cond: elems: mkIf cond (mkMerge elems);

  mapModules = dir: fn:
    mapFilterAttrs
      (n: v: v != null)
      (n: v:
        let
          path = "${toString dir}/${n}";
          isModuleDir  = v == "directory" && pathExists "${path}/default.nix";
          isModuleFile = (
            v == "regular"
            && n != "default.nix"
            && hasSuffix ".nix" n
          );
        in
          if isModuleDir then
            nameValuePair n (fn path)
          else if isModuleFile then
            nameValuePair (removeSuffix ".nix" n) (fn path)
          else nameValuePair "" null)
      (readDir dir);
}
