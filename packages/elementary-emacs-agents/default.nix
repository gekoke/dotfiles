{
  lib,
  eca,
  emacsPackages,
  elementary-emacs-keys,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-agents";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.eca
  ];
  passthru.runtimeDeps = [ eca ];
  meta = {
    description = "AI coding agent support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
