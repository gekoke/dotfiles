;;; elementary-emacs-terraform.el --- Terraform language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (elementary-emacs-lsp "0.1") (terraform-mode "1.0"))
;; Keywords: languages

;;; Commentary:

;; Terraform major mode and language server.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package terraform-mode
  :hook (terraform-mode . lsp-deferred))

(provide 'elementary-emacs-terraform)
;;; elementary-emacs-terraform.el ends here
