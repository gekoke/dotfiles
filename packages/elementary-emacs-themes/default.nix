{
  lib,
  emacsPackages,
  elementary-emacs-keys,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-themes";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.catppuccin-theme
    emacsPackages.consult
    emacsPackages.doom-themes
    emacsPackages.ef-themes
    emacsPackages.gruvbox-theme
    emacsPackages.modus-themes
    emacsPackages.remember-last-theme
  ];
  meta = {
    description = "Themes for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
