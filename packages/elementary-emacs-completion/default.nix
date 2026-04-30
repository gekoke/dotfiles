{
  lib,
  emacsPackages,
  elementary-emacs-keys,
  ripgrep,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-completion";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.cape
    emacsPackages.consult
    emacsPackages.corfu
    emacsPackages.embark
    emacsPackages.embark-consult
    emacsPackages.general
    emacsPackages.marginalia
    emacsPackages.nerd-icons-completion
    emacsPackages.nerd-icons-corfu
    emacsPackages.orderless
    emacsPackages.rg
    emacsPackages.vertico
    emacsPackages.wgrep
    emacsPackages.which-key
  ];
  passthru.runtimeDeps = [
    ripgrep
  ];
  meta = {
    description = "Completion for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
