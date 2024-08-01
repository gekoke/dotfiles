{
  lib,
  emacsPackages,
  fetchgit,
  ...
}:
emacsPackages.trivialBuild rec {
  pname = "typst-ts-mode";
  version = "f179b08d";

  src = fetchgit {
    url = "https://git.sr.ht/~meow_king/typst-ts-mode";
    rev = version;
    sha256 = "sha256-kkuR4E8rN7gZ8oXPhKE6NaKnijX1CE0t8Sj0/kGEYzo=";
  };

  meta = {
    homepage = "https://git.sr.ht/~meow_king/typst-ts-mode";
    description = "Tree Sitter support for Typst.";
    license = lib.licenses.gpl3;
  };
}
