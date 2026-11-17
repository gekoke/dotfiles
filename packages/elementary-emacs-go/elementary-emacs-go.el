;;; elementary-emacs-go.el --- Go language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (elementary-emacs-lsp "0.1"))
;; Keywords: languages

;;; Commentary:

;; Go tree-sitter mode and gopls.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package go-ts-mode
  :hook (go-ts-mode . lsp)
  :custom
  (go-ts-mode-indent-offset tab-width))

(provide 'elementary-emacs-go)
;;; elementary-emacs-go.el ends here
