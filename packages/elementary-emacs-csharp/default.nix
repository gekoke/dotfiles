{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  dotnet-sdk_10,
  omnisharp-roslyn,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-csharp";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
  ];
  passthru.runtimeDeps = [
    dotnet-sdk_10
    omnisharp-roslyn
  ];
  meta = {
    description = "C# language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
