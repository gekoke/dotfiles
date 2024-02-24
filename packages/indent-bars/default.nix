{ lib
, emacsPackages
, fetchFromGitHub
, ...
}:
emacsPackages.trivialBuild rec {
  pname = "indent-bars";
  version = "13cebfa";

  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "indent-bars";
    rev = version;
    hash = "sha256-CY51OLcdR99CFbFlXYoJAX8qvnucORjhzQeT5Kd+v8E=";
  };

  packageRequires = [
    emacsPackages.compat
  ];

  meta = {
    homepage = "https://github.com/jdtsmith/indent-bars";
    description = "Fast, configurable indentation guide-bars for Emacs";
    license = lib.licenses.gpl3;
  };
}
