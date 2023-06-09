{ config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.programs.emacs;
in
{
  options.plusultra.programs.emacs = {
    enable = mkEnableOption "GNU Emacs";
  };

  config = let
    emacsPackage = pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs29-pgtk;
      config = ./init.el;
      alwaysEnsure = true;
      override = final: prev: {
        lsp-mode = prev.melpaPackages.lsp-mode.overrideAttrs(old: {
          LSP_USE_PLISTS = "true";
        });
      };
    };
    earlyInitText = readFiles [
      ./early-init.el
      ./early-init-pgtk-fixes.el
    ];
  in
    mkIf cfg.enable {
  	  # For emacs-overlay
      nix.settings = {
	      substituters = [ "https://nix-community.cachix.org" ];
	      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
	    };

      # LSP optimizations
      environment.sessionVariables.LSP_USE_PLISTS = "true";

      fonts.fonts = with pkgs; [
        # all-the-icons
        emacs-all-the-icons-fonts
      ];

      plusultra.home.packages = with pkgs; [
        # dirvish
        fd imagemagick ffmpegthumbnailer mediainfo gnutar unzip xpdf
        # consult
        ripgrep
        # lsp-nix
        nil nixpkgs-fmt
        # age
        rage
      ];

      plusultra.home = {
	      programs.emacs = enabled // { package = emacsPackage; };
	      file = {
	        ".emacs.d/init.el".source = ./init.el;
	        ".emacs.d/early-init.el".text = earlyInitText;
	      };
      };
    };
}
