{
  lib,
  emacsPackages,
  elementary-emacs-keys,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-lsp";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.cape
    emacsPackages.consult-lsp
    emacsPackages.flycheck
    emacsPackages.lsp-mode
    emacsPackages.lsp-ui
  ];
  meta = {
    description = "LSP support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
