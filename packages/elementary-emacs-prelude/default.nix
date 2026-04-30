{
  lib,
  emacsPackages,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-prelude";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    emacsPackages.undo-tree
  ];
  meta = {
    description = "Baseline Emacs defaults for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
