_:
_final: prev: {
  lsp-mode = prev.melpaPackages.lsp-mode.overrideAttrs (_: {
    LSP_USE_PLISTS = "true";
  });
}
