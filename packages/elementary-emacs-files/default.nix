{
  lib,
  emacsPackages,
  age,
  elementary-emacs-keys,
  fd,
  ffmpegthumbnailer,
  gnutar,
  mediainfo,
  poppler-utils,
  unzip,
  vips,
  ...
}:
emacsPackages.trivialBuild {
  pname = "elementary-emacs-files";
  version = "0.1.0";
  src = ./.;
  packageRequires = [
    elementary-emacs-keys
    emacsPackages.age
    emacsPackages.dired-gitignore
    emacsPackages.diredfl
    emacsPackages.dirvish
    emacsPackages.nerd-icons
    emacsPackages.pdf-tools
  ];
  passthru.runtimeDeps = [
    # keep-sorted start
    age
    fd
    ffmpegthumbnailer
    gnutar
    mediainfo
    poppler-utils
    unzip
    vips
    # keep-sorted end
  ];
  meta = {
    description = "File browsing for Elementary Emacs";
    license = lib.licenses.gpl3Plus;
  };
}
