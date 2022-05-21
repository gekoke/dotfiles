{ lib, fetchurl }:
let
  version = "1.0";
in fetchurl {
  name = "icomoon-feather-ttf";
  url = "https://github.com/adi1090x/polybar-themes/blob/4b0e9a95d48cc3e9b85934d33fcb776eae4a7bd7/polybar-4/fonts/icomoon-feather.ttf?raw=true";

  sha256 = "d74dc222a0ee04ebd2a169fed8eb437692a98833c06534f5450400fd024a9bbb";

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/icomoon-feather.ttf
  '';

  meta = with lib; {
    description = "Icomoon feather font";
    homepage = "https://github.com/feathericons/feather";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ gekoke ];
    platforms = platforms.all;
  };
}
