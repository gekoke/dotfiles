{
  lib,
  emacsPackages,
  elementary-emacs-lsp,
  cargo,
  clippy,
  rust-analyzer,
  rustc,
  rustfmt,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-rust";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-lsp
    emacsPackages.rustic
  ];
  passthru.runtimeDeps = [
    cargo
    clippy
    rust-analyzer
    rustc
    rustfmt
  ];
  meta = {
    description = "Rust language support for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
