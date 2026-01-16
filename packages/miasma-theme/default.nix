{
  lib,
  emacsPackages,
  fetchFromGitHub,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "miasma-theme";
  version = "998aa50769722f1a92f99124d76a1689c2d9eaf1";

  src = fetchFromGitHub {
    owner = "daut";
    repo = "miasma-theme.el";
    rev = version;
    hash = "sha256-O1Vdz+o2BvI6Zlws5blwx/BMrXlDX17HkxxI4AQiGv4=";
  };

  meta = {
    homepage = "https://github.com/daut/miasma-theme.el";
    license = lib.licenses.gpl3;
  };
}
