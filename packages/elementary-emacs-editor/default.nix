{
  lib,
  emacsPackages,
  elementary-emacs-keys,
  hunspell,
  hunspellDicts,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-editor";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.editorconfig
    emacsPackages.evil
    emacsPackages.evil-anzu
    emacsPackages.evil-collection
    emacsPackages.evil-matchit
    emacsPackages.evil-mc
    emacsPackages.evil-numbers
    emacsPackages.evil-surround
    emacsPackages.evil-textobj-tree-sitter
    emacsPackages.general
    emacsPackages.helpful
    emacsPackages.indent-bars
    emacsPackages.jinx
    emacsPackages.link-hint
    emacsPackages.treesit-auto
    emacsPackages.undo-tree
  ];
  passthru.runtimeDeps = [
    # keep-sorted start
    hunspell
    hunspellDicts.en_US
    # keep-sorted end
  ];
  meta = {
    description = "Editing experience for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
