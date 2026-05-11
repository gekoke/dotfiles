{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "wsl-notify-send";
  version = "0.1.871612270";

  src = fetchzip {
    url = "https://github.com/stuartleeks/wsl-notify-send/releases/download/v${version}/wsl-notify-send_windows_amd64.zip";
    hash = "sha256-ORvJbxkSw9Y3QAK9RCmfB6T3Ef8W0HKoJKDO2gGKQ4A=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/wsl-notify-send.exe $out/bin/wsl-notify-send.exe
    runHook postInstall
  '';

  meta = {
    description = "A drop-in replacement for notify-send that uses Windows notifications from WSL";
    homepage = "https://github.com/stuartleeks/wsl-notify-send";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "wsl-notify-send.exe";
  };
}
