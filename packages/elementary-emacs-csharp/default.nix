{
  lib,
  emacsPackages,
  replaceVars,
  runCommand,
  elementary-emacs-lsp,
  dotnet-sdk_11,
  roslyn-ls,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-csharp";
  version = "0.1.0";
  src = runCommand "elementary-emacs-csharp-src" { } ''
    mkdir -p $out
    cp ${
      replaceVars ./elementary-emacs-csharp.el {
        dotnet = "${dotnet-sdk_11}/bin/dotnet";
        roslynLsDll = "${roslyn-ls}/lib/roslyn-ls/Microsoft.CodeAnalysis.LanguageServer.dll";
      }
    } $out/elementary-emacs-csharp.el
  '';
  packageRequires = [
    elementary-emacs-lsp
  ];
  passthru.runtimeDeps = [
    dotnet-sdk_11
  ];
  meta = {
    description = "C# language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
