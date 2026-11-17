;;; elementary-emacs-powershell.el --- PowerShell language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (elementary-emacs-lsp "0.1") (powershell "2.0"))
;; Keywords: languages

;;; Commentary:

;; PowerShell major mode and editor services.

;;; Code:

(require 'elementary-emacs-lsp)

(setq lsp-pwsh-dir "@pwshDir@")

(use-package powershell
  :defer t)

(provide 'elementary-emacs-powershell)
;;; elementary-emacs-powershell.el ends here
