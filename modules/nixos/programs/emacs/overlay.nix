{ fetchFromGitHub }:
_final: prev: {
  lsp-mode = prev.melpaPackages.lsp-mode.overrideAttrs (_: {
    LSP_USE_PLISTS = "true";
  });

  dirvish = prev.melpaPackages.dirvish.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "hlissner";
      repo = "dirvish";
      rev = "5f04619";
      hash = "sha256-VCTbhevhPMVVwBdkT0gdxcSOrWOs4IjdemdZJVDq9W4=";
    };
  });
}
