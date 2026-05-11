{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  jdk25,
  jdt-language-server,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-java";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.lsp-java
  ];
  passthru.runtimeDeps = [
    jdk25
    jdt-language-server
  ];
  meta = {
    description = "Java language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
