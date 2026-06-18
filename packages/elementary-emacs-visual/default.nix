{
  lib,
  emacsPackages,
  elementary-emacs-keys,
  auto-olivetti,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-visual";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    auto-olivetti
    emacsPackages.consult
    emacsPackages.dashboard
    emacsPackages.doom-modeline
    emacsPackages.ligature
    emacsPackages.nerd-icons
    emacsPackages.nyan-mode
    emacsPackages.olivetti
    emacsPackages.rainbow-delimiters
  ];
  meta = {
    description = "Visual UI for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
