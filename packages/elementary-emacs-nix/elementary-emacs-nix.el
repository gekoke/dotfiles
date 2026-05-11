;;; elementary-emacs-nix.el --- Nix language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (nix-ts-mode "0.1") (elementary-emacs-lsp "0.1"))
;; Keywords: languages

;;; Commentary:

;; Nix major mode and LSP wiring.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package lsp-nix
  :after lsp-mode
  :custom
  (lsp-nix-nil-formatter ["nixfmt"]))

(use-package nix-ts-mode
  :mode "\\.nix\\'"
  :hook (nix-ts-mode . lsp-deferred))

(provide 'elementary-emacs-nix)
;;; elementary-emacs-nix.el ends here
