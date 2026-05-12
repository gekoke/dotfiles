;;; elementary-emacs-csharp.el --- C# language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (elementary-emacs-lsp "0.1"))
;; Keywords: languages

;;; Commentary:

;; C# major mode and LSP wiring.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package csharp-ts-mode
  :mode ("\\.cs\\'" . csharp-ts-mode)
  :hook (csharp-ts-mode . lsp-deferred))

(provide 'elementary-emacs-csharp)
;;; elementary-emacs-csharp.el ends here
