{
  lib,
  emacsPackages,
  replaceVars,
  runCommand,
  elementary-emacs-lsp,
  nodejs,
  tailwindcss-language-server,
  typescript,
  vscode-langservers-extracted,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-web";
  version = "0.1.0";
  src = runCommand "elementary-emacs-web-src" { } ''
    mkdir -p $out
    cp ${
      replaceVars ./elementary-emacs-web.el {
        tailwindcssLs = lib.getExe tailwindcss-language-server;
        tsgo = lib.getExe' typescript "tsc";
      }
    } $out/elementary-emacs-web.el
  '';
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.web-mode
  ];
  passthru.runtimeDeps = [
    nodejs
    tailwindcss-language-server
    typescript
    vscode-langservers-extracted
  ];
  meta = {
    description = "Web (HTML/CSS/JSON/TS/JS/Tailwind) support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
