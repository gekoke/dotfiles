{
  lib,
  emacsPackages,
  elementary-emacs-keys,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-terminal";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.evil
    emacsPackages.general
    emacsPackages.vterm
    emacsPackages.vterm-toggle
  ];
  meta = {
    description = "Terminal integration for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
