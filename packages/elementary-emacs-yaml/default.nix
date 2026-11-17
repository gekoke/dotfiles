{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  yaml-language-server,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-yaml";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.yaml-mode
  ];
  passthru.runtimeDeps = [ yaml-language-server ];
  meta = {
    description = "YAML language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
