;;; elementary-emacs-java.el --- Java language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (lsp-java "3.1") (elementary-emacs-lsp "0.1"))
;; Keywords: languages

;;; Commentary:

;; Java major mode and LSP wiring.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package lsp-java
  :hook (java-ts-mode . (lambda ()
                          (load "lsp-java.el")
                          (lsp-deferred))))

(provide 'elementary-emacs-java)
;;; elementary-emacs-java.el ends here
