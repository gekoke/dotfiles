{ pkgs, ... }:
let
  installTarget = "$out/share/wallpapers";
in
pkgs.stdenvNoCC.mkDerivation {
  name = "wallpapers";
  src = ./wallpapers;
  installPhase = ''
    mkdir -p ${installTarget}
    find * -type f -exec cp ./{} ${installTarget}/{} \;
  '';
}
