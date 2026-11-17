{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  terraform,
  terraform-ls,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-terraform";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.terraform-mode
  ];
  passthru.runtimeDeps = [
    terraform
    terraform-ls
  ];
  meta = {
    description = "Terraform language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
