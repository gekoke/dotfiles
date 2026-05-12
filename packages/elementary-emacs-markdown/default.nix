{
  lib,
  emacsPackages,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-markdown";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    emacsPackages.markdown-mode
  ];
  meta = {
    description = "Markdown language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
