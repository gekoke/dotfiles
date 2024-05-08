{
  lib,
  emacsPackages,
  fetchFromGitHub,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "indent-bars";
  version = "74c08d8";

  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "indent-bars";
    rev = version;
    hash = "sha256-fTbDjWHO7DRGtlsbU1YXat/lLACxqdXU2tNuZMagkh0=";
  };

  packageRequires = [ emacsPackages.compat ];

  meta = {
    homepage = "https://github.com/jdtsmith/indent-bars";
    description = "Fast, configurable indentation guide-bars for Emacs";
    license = lib.licenses.gpl3;
  };
}
