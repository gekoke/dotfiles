{ config
, lib
, pkgs
, inputs
, ...
}:
with lib; let
  cfg = config.modules.emacs;

  doomConfigRepo = "https://github.com/gekoke/doom-emacs-config";

  doomSetupScript = pkgs.writeShellScriptBin "doominit" ''
    git clone --depth=1 --single-branch https://github.com/doomemacs/doomemacs "$XDG_CONFIG_HOME/emacs"
    git clone ${doomConfigRepo} "$XDG_CONFIG_HOME/doom"
    doom install
  '';
in
{
  options.modules.emacs = {
    enable = mkEnableOption "Whether to enable Doom Emacs";
  };

  config = mkIf cfg.enable {
    xdg.enable = true;

    programs.emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; [ vterm ];
    };

    home = {
      # Vterm compile
      sessionVariables.CC = "make";

      packages = with pkgs; [
        doomSetupScript

        # Vterm dependency
        gnumake
        cmake

        ## Doom dependencies
        git
        (ripgrep.override { withPCRE2 = true; })
        gnutls # for TLS connectivity

        ## Optional dependencies
        fd # faster projectile indexing
        imagemagick # for image-dired
        zstd # for undo-fu-session/undo-tree compression

        ## Module dependencies
        pandoc # Markdown
        # :checkers spell
        (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
        # :tools editorconfig
        editorconfig-core-c # per-project style config
        # :tools lookup & :lang org +roam
        sqlite
        # :lang latex & :lang org (latex previews)
        #texlive.combined.scheme-medium
        # :lang beancount
        #beancount
        #unstable.fava  # HACK Momentarily broken on nixos-unstable
        emacs-all-the-icons-fonts
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
          ];
        })
      ];

      sessionPath = [ "${config.home.sessionVariables.XDG_CONFIG_HOME}/emacs/bin" ];
      shellAliases."e" = "doom run";
    };

    fonts.fontconfig.enable = true;
  };
}
