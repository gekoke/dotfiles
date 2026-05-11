;;; elementary-emacs-python.el --- Python language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (lsp-pyright "0.4") (elementary-emacs-lsp "0.1"))
;; Keywords: languages

;;; Commentary:

;; Python major mode, LSP, and format-on-save.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package lsp-pyright
  :hook (python-ts-mode . (lambda ()
                            (require 'lsp-pyright)
                            (lsp-deferred)))
  :custom
  (lsp-pyright-venv-directory "./.venv"))

(use-package lsp-ruff
  :after lsp-mode)

(use-package python
  :defer t
  :init
  (add-hook 'before-save-hook (lambda ()
                                (when (and
                                       (eq major-mode 'python-ts-mode)
                                       (bound-and-true-p lsp-mode))
                                  (lsp-format-buffer)))))

(provide 'elementary-emacs-python)
;;; elementary-emacs-python.el ends here
