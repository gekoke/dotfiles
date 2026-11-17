{
  lib,
  emacsPackages,
  replaceVars,
  runCommand,
  elementary-emacs-lsp,
  powershell-editor-services,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-powershell";
  version = "0.1.0";
  src = runCommand "elementary-emacs-powershell-src" { } ''
    mkdir -p $out
    cp ${
      replaceVars ./elementary-emacs-powershell.el {
        pwshDir = "${powershell-editor-services}/lib/powershell-editor-services";
      }
    } $out/elementary-emacs-powershell.el
  '';
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.powershell
  ];
  meta = {
    description = "PowerShell language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
