{ lib, ... }:
with lib; let
  inherit self;
in
rec {
  isRGBHex = value: !isNull (builtins.match "#[[:xdigit:]]{6}|[[:xdigit:]]{6}" value);

  palette = mkOptionType {
    name = "palette";
    description = "color palette applied globally";
    merge = mergeEqualOption;
    check = value:
      isAttrs value
      && all (attr: hasAttr attr value && isRGBHex (getAttr attr value)) [
        "base0"
        "base1"
        "base2"
        "base3"
        "lite0"
        "lite1"
        "lite2"
        "colo0"
        "colo1"
        "colo2"
        "colo3"
      ];
  };
}
