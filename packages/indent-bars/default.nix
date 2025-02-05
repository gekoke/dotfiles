{
  lib,
  emacsPackages,
  fetchFromGitHub,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "indent-bars";
  version = "2722d50";

  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "indent-bars";
    rev = version;
    hash = "sha256-Vqad6dkwhtatvTrgtZDewe51oHOowoR5ANI2HJwzXJg=";
  };

  packageRequires = [ emacsPackages.compat ];

  meta = {
    homepage = "https://github.com/jdtsmith/indent-bars";
    description = "Fast, configurable indentation guide-bars for Emacs";
    license = lib.licenses.gpl3;
  };
}
