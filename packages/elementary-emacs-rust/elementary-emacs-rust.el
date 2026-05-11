;;; elementary-emacs-rust.el --- Rust language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (rustic "4.1") (elementary-emacs-lsp "0.1"))
;; Keywords: languages

;;; Commentary:

;; Rust major mode, format-on-save, and rust-analyzer tuning.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package rustic
  :mode
  ("\\.rs\\'" . rustic-mode)
  :custom
  (rustic-format-trigger t))

(use-package lsp-rust
  :after lsp-mode
  :custom
  (lsp-rust-analyzer-lens-references-adt-enable t)
  (lsp-rust-analyzer-lens-references-trait-enable t)
  (lsp-rust-analyzer-lens-references-enum-variant-enable t)
  (lsp-rust-analyzer-max-inlay-hint-length 15)
  (lsp-rust-analyzer-diagnostics-enable-experimental t)
  (lsp-rust-clippy-preference "on"))

(provide 'elementary-emacs-rust)
;;; elementary-emacs-rust.el ends here
