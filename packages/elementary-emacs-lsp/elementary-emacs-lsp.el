;;; elementary-emacs-lsp.el --- LSP support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (cape "1.0") (consult-lsp "0.1") (flycheck "32") (lsp-mode "9.0") (lsp-ui "9.0") (elementary-emacs-keys "0.1"))
;; Keywords: tools

;;; Commentary:

;; Language-agnostic LSP support: lsp-mode, lsp-ui, consult-lsp, and flycheck.

;;; Code:

(require 'elementary-emacs-keys)

(use-package flycheck
  :hook (after-init . global-flycheck-mode)
  :custom
  (flycheck-indication-mode 'right-fringe))

(use-package lsp-mode
  :init
  (defun gg/setup-lsp-mode-capf ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))
    (setq-local completion-at-point-functions (list
                                               (cape-capf-buster (cape-capf-nonexclusive #'lsp-completion-at-point))
                                               #'cape-file
                                               #'cape-dabbrev
                                               #'cape-keyword)))

  ;; Set mode-gating variables before `lsp-mode' loads so that the per-buffer
  ;; mode-enable code consulted during the first `lsp' invocation sees the
  ;; intended values.  `:custom' fires too late for these (it runs after
  ;; `lsp-mode' is loaded, by which point the relevant `defcustom' defaults
  ;; have already been observed and the sub-modes activated).
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-inlay-hint-enable t)
  (setq lsp-semantic-tokens-enable t)
  (setq lsp-semantic-tokens-honor-refresh-requests t)
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  (lsp-completion-mode . gg/setup-lsp-mode-capf)
  :custom
  (lsp-signature-function #'lsp-signature-posframe)
  (lsp-go-analyses '((shadow . t)
                     (simplifycompositelit . :json-false)))
  :general
  (general-def
    :keymaps '(lsp-mode-map)
    :states '(normal)
    "g r" #'lsp-find-references)
  (gg/leader lsp-mode-map
    "l" '(:keymap lsp-command-map))
  (general-def lsp-command-map
    "= r" #'lsp-format-region))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-sideline-diagnostic-max-line-length 280)
  :general
  (general-def
    :keymaps '(lsp-ui-mode-map)
    :states '(normal)
    "g h" #'lsp-ui-doc-glance
    "g H" #'lsp-describe-thing-at-point
    "g n" #'lsp-ui-find-next-reference
    "g N" #'lsp-ui-find-prev-reference))

(use-package consult-lsp
  :after lsp-mode
  :general
  (general-def lsp-command-map
    "s s" #'consult-lsp-symbols
    "s f" #'consult-lsp-file-symbols
    "s d" #'consult-lsp-diagnostics))

(provide 'elementary-emacs-lsp)
;;; elementary-emacs-lsp.el ends here
