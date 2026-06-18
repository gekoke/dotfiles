{
  lib,
  emacsPackages,
  fetchFromSourcehut,
  ...
}:
emacsPackages.trivialBuild {
  pname = "auto-olivetti";
  version = "1.0.0-rc";
  src = fetchFromSourcehut {
    owner = "~ashton314";
    repo = "auto-olivetti";
    rev = "406b2fca6b320f323d6d2f96240bc4c8551c12a9";
    hash = "sha256-ghfEyMiEM0Z3kRerKyFh+m7ZeBquU52Y7cKH0YiIaOY=";
  };
  packageRequires = [
    emacsPackages.olivetti
  ];
  meta = {
    description = "Automatically enable olivetti-mode in wide windows";
    homepage = "https://sr.ht/~ashton314/auto-olivetti";
    license = lib.licenses.mit;
  };
}
