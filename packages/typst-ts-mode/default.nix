{
  lib,
  emacsPackages,
  fetchgit,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "typst-ts-mode";
  version = "d3e44b53";

  src = fetchgit {
    url = "https://codeberg.org/meow_king/typst-ts-mode";
    rev = version;
    sha256 = "sha256-fECXfTjbckgS+kEJ3dMQ7zDotqdxxBt3WFl0sEM60Aw=";
  };

  meta = {
    homepage = "https://codeberg.org/meow_king/typst-ts-mode";
    description = "Tree Sitter support for Typst.";
    license = lib.licenses.gpl3;
  };
}
