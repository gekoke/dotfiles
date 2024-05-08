{
  lib,
  emacsPackages,
  fetchFromGitHub,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "kanagawa-theme";
  version = "2023-09-15";

  src = fetchFromGitHub {
    owner = "konrad1977";
    repo = "kanagawa-emacs";
    rev = "d6e590948b72330905ebc65226f55b250c496429";
    hash = "sha256-/vMjvsNXKktiX1a7gtkkbwvAeC3wPGtzExuMf0YXo1w=";
  };

  buildInputs = propagatedUserEnvPkgs;

  propagatedUserEnvPkgs = [ emacsPackages.autothemer ];

  meta = {
    homepage = "https://github.com/konrad1977/kanagawa-emacs";
    description = "A theme inspired by the colors of the famous painting by Katsushika Hokusa";
    license = lib.licenses.agpl3Plus;
  };
}
