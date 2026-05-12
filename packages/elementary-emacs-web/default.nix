{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  nodejs,
  tailwindcss-language-server,
  typescript,
  typescript-language-server,
  vscode-langservers-extracted,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-web";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.lsp-tailwindcss
    emacsPackages.web-mode
  ];
  passthru.runtimeDeps = [
    nodejs
    tailwindcss-language-server
    typescript
    typescript-language-server
    vscode-langservers-extracted
  ];
  meta = {
    description = "Web (HTML/CSS/JSON/TS/JS/Tailwind) support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
