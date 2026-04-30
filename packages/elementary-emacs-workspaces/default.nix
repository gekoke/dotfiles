{
  lib,
  emacsPackages,
  elementary-emacs-keys,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-workspaces";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.ace-window
    emacsPackages.dashboard
    emacsPackages.eyebrowse
    emacsPackages.general
  ];
  meta = {
    description = "Window and workspace management for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
