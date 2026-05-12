{
  lib,
  emacs,
  emacsPackages,
  makeWrapper,
  runCommand,
  replaceVars,
  elementary-emacs-completion,
  elementary-emacs-csharp,
  elementary-emacs-editor,
  elementary-emacs-files,
  elementary-emacs-java,
  elementary-emacs-keys,
  elementary-emacs-lsp,
  elementary-emacs-markdown,
  elementary-emacs-nix,
  elementary-emacs-prelude,
  elementary-emacs-python,
  elementary-emacs-rust,
  elementary-emacs-terminal,
  elementary-emacs-themes,
  elementary-emacs-vc,
  elementary-emacs-visual,
  elementary-emacs-web,
  elementary-emacs-workspaces,
  # keep-sorted start
  age,
  fd,
  ffmpegthumbnailer,
  gnutar,
  go,
  gopls,
  hunspell,
  hunspellDicts,
  mediainfo,
  omnisharp-roslyn,
  poppler-utils,
  powershell-editor-services,
  ripgrep,
  tailwindcss-language-server,
  terraform,
  terraform-ls,
  tinymist,
  typescript-language-server,
  unzip,
  vips,
  yaml-language-server,
  # keep-sorted end
}:
let
  elementaryPackages = [
    # keep-sorted start
    elementary-emacs-completion
    elementary-emacs-csharp
    elementary-emacs-editor
    elementary-emacs-files
    elementary-emacs-java
    elementary-emacs-keys
    elementary-emacs-lsp
    elementary-emacs-markdown
    elementary-emacs-nix
    elementary-emacs-prelude
    elementary-emacs-python
    elementary-emacs-rust
    elementary-emacs-terminal
    elementary-emacs-themes
    elementary-emacs-vc
    elementary-emacs-visual
    elementary-emacs-web
    elementary-emacs-workspaces
    # keep-sorted end
  ];

  loosePackages = epkgs: [
    # keep-sorted start
    epkgs.age
    epkgs.docker
    epkgs.gptel
    epkgs.pdf-tools
    epkgs.powershell
    epkgs.sideline-blame
    epkgs.terraform-mode
    epkgs.typst-ts-mode
    epkgs.yaml-mode
    # keep-sorted end
  ];

  emacsWithPackages = emacsPackages.emacsWithPackages (
    epkgs: elementaryPackages ++ loosePackages epkgs
  );

  runtimeBins = [
    # keep-sorted start
    age
    fd
    ffmpegthumbnailer
    gnutar
    go
    gopls
    hunspell
    hunspellDicts.en_US
    mediainfo
    poppler-utils
    ripgrep
    terraform
    terraform-ls
    tinymist
    unzip
    vips
    yaml-language-server
    # keep-sorted end
  ]
  ++ lib.concatMap (p: p.passthru.runtimeDeps or [ ]) elementaryPackages;

  initFile = replaceVars ../../modules/nixos/programs/emacs/init.el {
    omnisharp = "${omnisharp-roslyn}";
    pwshDir = "${powershell-editor-services}/lib/powershell-editor-services";
    tailwindcssLs = lib.getExe tailwindcss-language-server;
    typescriptLs = lib.getExe typescript-language-server;
  };
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
      --set LSP_USE_PLISTS true \
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
