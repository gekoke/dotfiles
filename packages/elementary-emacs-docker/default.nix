{
  lib,
  emacsPackages,
  elementary-emacs-keys,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-docker";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.docker
  ];
  meta = {
    description = "Docker support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
