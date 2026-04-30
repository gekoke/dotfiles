{
  lib,
  emacsPackages,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-keys";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    emacsPackages.general
  ];
  meta = {
    description = "Leader-key definers for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
