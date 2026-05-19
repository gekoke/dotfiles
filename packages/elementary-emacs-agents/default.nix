{
  lib,
  opencode,
  emacsPackages,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-agents";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    emacsPackages.agent-shell
  ];
  passthru.runtimeDeps = [ opencode ];
  meta = {
    description = "AI coding agent support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
