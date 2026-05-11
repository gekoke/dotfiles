{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  nixd,
  nixfmt,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-nix";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.nix-ts-mode
  ];
  passthru.runtimeDeps = [
    nixd
    nixfmt
  ];
  meta = {
    description = "Nix language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
