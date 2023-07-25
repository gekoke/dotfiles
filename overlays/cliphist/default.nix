{ channels, ... }:

final: prev:
{
  cliphist = prev.cliphist.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      mkdir -p $out/contrib
      cp -r $src/contrib/* $out/contrib/
    '';
  });
}
