{ self, lib }:
with builtins;
with lib;
let
  inherit (self.attrs) mapFilterAttrs;
in
rec
{
  mkMergeIf = cond: elems: mkIf cond (mkMerge elems);

  mapModules = dir: fn:
    mapFilterAttrs
      (n: v: v != null && !(hasPrefix "_" n))
      (n: v:
        let
          path         = "${toString dir}/${n}";
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

  mapModulesRec = dir: fn:
    mapFilterAttrs
      (n: v: v != null && !(hasPrefix "_" n))
      (n: v:
        let
          path         = "${toString dir}/${n}";
          isModuleDir  = v == "directory";
          isModuleFile = (
            v == "regular"
            && n != "default.nix"
            && hasSuffix ".nix" n
          );
        in
          if isModuleDir then
            nameValuePair n (mapModulesRec path fn)
          else if isModuleFile then
            nameValuePair (removeSuffix ".nix" n) (fn path)
          else nameValuePair "" null)
      (readDir dir);

  mapModulesRec' = dir: fn:
    let
      files = attrValues (mapModules dir id);
      paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
      dirs  =
        mapAttrsToList
          (k: _: "${dir}/${k}")
          (filterAttrs
            (n: v: v == "directory" && !(hasPrefix "_" n))
            (readDir dir));
    in
      map fn paths;
}
