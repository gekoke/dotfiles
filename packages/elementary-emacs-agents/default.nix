{
  lib,
  claude-agent-acp,
  elementary-emacs-keys,
  emacsPackages,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-agents";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.agent-shell
    emacsPackages.gptel
  ];
  passthru.runtimeDeps = [ claude-agent-acp ];
  meta = {
    description = "AI coding agent support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
