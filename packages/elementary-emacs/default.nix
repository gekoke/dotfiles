{
  lib,
  emacs,
  emacsPackages,
  linkFarm,
  makeWrapper,
  symlinkJoin,
  elementary-emacs-agents,
  elementary-emacs-completion,
  elementary-emacs-csharp,
  elementary-emacs-docker,
  elementary-emacs-editor,
  elementary-emacs-files,
  elementary-emacs-go,
  elementary-emacs-keys,
  elementary-emacs-lsp,
  elementary-emacs-markdown,
  elementary-emacs-nix,
  elementary-emacs-powershell,
  elementary-emacs-prelude,
  elementary-emacs-python,
  elementary-emacs-rust,
  elementary-emacs-terraform,
  elementary-emacs-terminal,
  elementary-emacs-themes,
  elementary-emacs-typst,
  elementary-emacs-vc,
  elementary-emacs-visual,
  elementary-emacs-web,
  elementary-emacs-workspaces,
  elementary-emacs-yaml,
}:
let
  elementaryPackages = [
    # keep-sorted start
    elementary-emacs-agents
    elementary-emacs-completion
    elementary-emacs-csharp
    elementary-emacs-docker
    elementary-emacs-editor
    elementary-emacs-files
    elementary-emacs-go
    elementary-emacs-keys
    elementary-emacs-lsp
    elementary-emacs-markdown
    elementary-emacs-nix
    elementary-emacs-powershell
    elementary-emacs-prelude
    elementary-emacs-python
    elementary-emacs-rust
    elementary-emacs-terminal
    elementary-emacs-terraform
    elementary-emacs-themes
    elementary-emacs-typst
    elementary-emacs-vc
    elementary-emacs-visual
    elementary-emacs-web
    elementary-emacs-workspaces
    elementary-emacs-yaml
    # keep-sorted end
  ];

  emacsWithPackages = emacsPackages.emacsWithPackages (_: elementaryPackages);

  binPath = lib.makeBinPath (lib.concatMap (p: p.passthru.runtimeDeps or [ ]) elementaryPackages);

  initDirectory = linkFarm "elementary-emacs-config" {
    "init.el" = ./init.el;
    "early-init.el" = ./early-init.el;
  };
in
symlinkJoin {
  name = "elementary-emacs";
  paths = [ emacsWithPackages ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/emacs \
      --prefix PATH : ${binPath} \
      --add-flags "--init-directory=${initDirectory}"
    wrapProgram $out/bin/emacsclient --prefix PATH : ${binPath}
  '';
  meta = {
    description = "Elementary Emacs: opinionated GNU Emacs distribution";
    license = lib.licenses.gpl3Plus;
    mainProgram = "emacs";
    inherit (emacs.meta) platforms;
  };
}
