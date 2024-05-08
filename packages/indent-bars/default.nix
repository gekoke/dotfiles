{
  lib,
  emacsPackages,
  fetchFromGitHub,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "indent-bars";
  version = "8826105";

  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "indent-bars";
    rev = version;
    hash = "sha256-usa8xpg2dvXwFcQf8gKSZ+kOy6EGJ+e2mkvGAjEX66o=";
  };

  packageRequires = [ emacsPackages.compat ];

  meta = {
    homepage = "https://github.com/jdtsmith/indent-bars";
    description = "Fast, configurable indentation guide-bars for Emacs";
    license = lib.licenses.gpl3;
  };
}
