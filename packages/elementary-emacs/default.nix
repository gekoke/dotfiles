{
  lib,
  emacs,
  emacsPackages,
  makeWrapper,
  runCommand,
  replaceVars,
  # Elementary elisp packages
  elementary-emacs-completion,
  elementary-emacs-editor,
  elementary-emacs-files,
  elementary-emacs-keys,
  elementary-emacs-lsp,
  elementary-emacs-nix,
  elementary-emacs-prelude,
  elementary-emacs-python,
  elementary-emacs-terminal,
  elementary-emacs-themes,
  elementary-emacs-vc,
  elementary-emacs-visual,
  elementary-emacs-workspaces,
  # Loose elisp deps (transitionally used until extracted to lang/tier packages)
  # keep-sorted start
  age,
  cargo,
  clippy,
  dotnet-sdk_10,
  fd,
  ffmpegthumbnailer,
  gnutar,
  go,
  gopls,
  hunspell,
  hunspellDicts,
  jdk25,
  jdt-language-server,
  mediainfo,
  nodejs,
  omnisharp-roslyn,
  poppler-utils,
  powershell,
  powershell-editor-services,
  ripgrep,
  rust-analyzer,
  rustc,
  rustfmt,
  tailwindcss-language-server,
  terraform,
  terraform-ls,
  tinymist,
  typescript,
  typescript-language-server,
  unzip,
  vips,
  vscode-langservers-extracted,
  yaml-language-server,
  # keep-sorted end
}:
let
  initSrcDir = ../../modules/nixos/programs/emacs;
  elementaryPackages = [
    # keep-sorted start
    elementary-emacs-completion
    elementary-emacs-editor
    elementary-emacs-files
    elementary-emacs-keys
    elementary-emacs-lsp
    elementary-emacs-nix
    elementary-emacs-prelude
    elementary-emacs-python
    elementary-emacs-terminal
    elementary-emacs-themes
    elementary-emacs-vc
    elementary-emacs-visual
    elementary-emacs-workspaces
    # keep-sorted end
  ];
  loosePackages = epkgs: [
    # keep-sorted start
    epkgs.age
    epkgs.docker
    epkgs.emacs
    epkgs.gptel
    epkgs.lsp-java
    epkgs.lsp-tailwindcss
    epkgs.markdown-mode
    epkgs.pdf-tools
    epkgs.powershell
    epkgs.rustic
    epkgs.sideline-blame
    epkgs.terraform-mode
    epkgs.treesit-grammars.with-all-grammars
    epkgs.typst-ts-mode
    epkgs.web-mode
    epkgs.yaml-mode
    # keep-sorted end
  ];
  emacsWithPackages = emacsPackages.emacsWithPackages (
    epkgs: elementaryPackages ++ (loosePackages epkgs)
  );
  runtimeBins = [
    # keep-sorted start
    age
    cargo
    clippy
    dotnet-sdk_10
    fd
    ffmpegthumbnailer
    gnutar
    go
    gopls
    hunspell
    hunspellDicts.en_US
    jdk25
    jdt-language-server
    mediainfo
    nodejs
    omnisharp-roslyn
    poppler-utils
    powershell
    ripgrep
    rust-analyzer
    rustc
    rustfmt
    tailwindcss-language-server
    terraform
    terraform-ls
    tinymist
    typescript
    typescript-language-server
    unzip
    vips
    vscode-langservers-extracted
    yaml-language-server
    # keep-sorted end
  ]
  ++ lib.concatMap (p: p.passthru.runtimeDeps or [ ]) elementaryPackages;
  initFile = replaceVars (initSrcDir + "/init.el") {
    omnisharp = "${omnisharp-roslyn}";
    pwshDir = "${powershell-editor-services}/lib/powershell-editor-services";
    tailwindcssLs = lib.getExe tailwindcss-language-server;
    typescriptLs = lib.getExe typescript-language-server;
  };
  earlyInitFile = runCommand "elementary-emacs-early-init.el" { } ''
    cat ${initSrcDir}/early-init.el \
        ${initSrcDir}/early-init-pgtk-fixes.el \
        > $out
    cat >> $out <<'EOF'

    ;; Redirect runtime writes off the read-only Nix store.
    (setq user-emacs-directory
          (expand-file-name "elementary-emacs/"
                            (or (getenv "XDG_DATA_HOME")
                                "~/.local/share")))
    (make-directory user-emacs-directory t)
    EOF
  '';
in
runCommand "elementary-emacs"
  {
    nativeBuildInputs = [ makeWrapper ];
    passthru = {
      inherit emacs emacsPackages emacsWithPackages;
      unwrapped = emacsWithPackages;
    };
    meta = {
      description = "Elementary Emacs: opinionated GNU Emacs distribution";
      license = lib.licenses.gpl3Plus;
      mainProgram = "emacs";
      inherit (emacs.meta) platforms;
    };
  }
  ''
    mkdir -p $out/bin $out/share/elementary-emacs
    cp ${initFile} $out/share/elementary-emacs/init.el
    cp ${earlyInitFile} $out/share/elementary-emacs/early-init.el

    for bin in ${emacsWithPackages}/bin/*; do
      name=$(basename "$bin")
      makeWrapper "$bin" "$out/bin/$name" \
        --set LSP_USE_PLISTS true \
        --prefix PATH : ${lib.makeBinPath runtimeBins} \
        --add-flags "--init-directory=$out/share/elementary-emacs"
    done

    # Pass-through extra resources from emacsWithPackages where useful.
    for d in share/applications share/icons share/info share/man; do
      if [ -d ${emacsWithPackages}/$d ]; then
        mkdir -p $out/$d
        ln -s ${emacsWithPackages}/$d/* $out/$d/
      fi
    done
  ''
