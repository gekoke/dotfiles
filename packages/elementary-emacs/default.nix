{
  lib,
  emacs,
  emacsPackages,
  makeWrapper,
  runCommand,
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

  runtimeBins = lib.concatMap (p: p.passthru.runtimeDeps or [ ]) elementaryPackages;

  initFile = ./init.el;
  earlyInitFile = ./early-init.el;
in
runCommand "elementary-emacs"
  {
    nativeBuildInputs = [ makeWrapper ];
    meta = {
      description = "Elementary Emacs: opinionated GNU Emacs distribution";
      license = lib.licenses.gpl3Plus;
      mainProgram = "emacs";
      inherit (emacs.meta) platforms;
    };
  }
  ''
    mkdir -p $out/bin
    install -Dm644 ${initFile} $out/share/elementary-emacs/init.el
    install -Dm644 ${earlyInitFile} $out/share/elementary-emacs/early-init.el

    makeWrapper ${emacsWithPackages}/bin/emacs $out/bin/emacs \
      --prefix PATH : ${lib.makeBinPath runtimeBins} \
      --add-flags "--init-directory=$out/share/elementary-emacs"

    makeWrapper ${emacsWithPackages}/bin/emacsclient $out/bin/emacsclient \
      --prefix PATH : ${lib.makeBinPath runtimeBins}

    if [ -d ${emacsWithPackages}/share/applications ]; then
      ln -s ${emacsWithPackages}/share/applications $out/share/applications
    fi
    if [ -d ${emacsWithPackages}/share/icons ]; then
      ln -s ${emacsWithPackages}/share/icons $out/share/icons
    fi
  ''
