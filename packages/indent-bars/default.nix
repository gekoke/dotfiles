{
  lib,
  emacsPackages,
  fetchFromGitHub,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "indent-bars";
  version = "b72fa09";

  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "indent-bars";
    rev = version;
    hash = "sha256-xBwtj991wy2O764ATBEILsGk597f7pkCmDfbF+tbjns=";
  };

  packageRequires = [ emacsPackages.compat ];

  meta = {
    homepage = "https://github.com/jdtsmith/indent-bars";
    description = "Fast, configurable indentation guide-bars for Emacs";
    license = lib.licenses.gpl3;
  };
}
