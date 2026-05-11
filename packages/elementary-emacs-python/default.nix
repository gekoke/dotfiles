{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  pyright,
  ruff,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-python";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.lsp-pyright
  ];
  passthru.runtimeDeps = [
    pyright
    ruff
  ];
  meta = {
    description = "Python language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
