;;; elementary-emacs-yaml.el --- YAML language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (elementary-emacs-lsp "0.1") (yaml-mode "0.0"))
;; Keywords: languages

;;; Commentary:

;; YAML major mode and language server.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package yaml-mode
  :hook (yaml-mode . lsp))

(provide 'elementary-emacs-yaml)
;;; elementary-emacs-yaml.el ends here
