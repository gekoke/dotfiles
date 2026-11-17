{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  go,
  gopls,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-go";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
  ];
  passthru.runtimeDeps = [
    go
    gopls
  ];
  meta = {
    description = "Go language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
