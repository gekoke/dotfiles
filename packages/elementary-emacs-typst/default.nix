{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  tinymist,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-typst";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.typst-ts-mode
  ];
  passthru.runtimeDeps = [ tinymist ];
  meta = {
    description = "Typst language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
