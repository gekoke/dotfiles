_final: prev: {
  emacsPackages = prev.emacsPackages.overrideScope (
    _epkgsFinal: epkgsPrev: {
      lsp-mode = epkgsPrev.lsp-mode.override {
        melpaBuild = args: epkgsPrev.melpaBuild (args // { env.LSP_USE_PLISTS = "true"; });
      };

      magit = epkgsPrev.magit.override {
        melpaBuild =
          args:
          epkgsPrev.melpaBuild (
            args
            // {
              # Try out syntax highlighting - see https://github.com/magit/magit/issues/2942#issuecomment-4093865954
              # FIXME: remove pin
              src = prev.fetchFromGitHub {
                owner = "gekoke";
                repo = "magit";
                rev = "c3cb836320d4ec491fa7168718218f46a61293dc";
                hash = "sha256-htq1A6lr+iJunhl8mqyKpbAaaNZ2XZoBYDGDqoVtJSg=";
              };
            }
          );
      };
    }
  );
}
