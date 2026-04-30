{
  lib,
  emacsPackages,
  elementary-emacs-keys,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-vc";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.diff-hl
    emacsPackages.forge
    emacsPackages.general
    emacsPackages.hl-todo
    emacsPackages.magit
    emacsPackages.magit-todos
  ];
  meta = {
    description = "Version control integration for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
