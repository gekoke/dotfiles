;;; elementary-emacs-lsp.el --- LSP support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (cape "1.0") (consult-lsp "0.1") (envrc "0.10") (flycheck "32") (general "0.1") (lsp-mode "9.0") (lsp-ui "9.0") (yasnippet "0.14") (elementary-emacs-keys "0.1"))
;; Keywords: tools

;;; Commentary:

;; Language-agnostic LSP support for Elementary Emacs:
;; lsp-mode (with `emacs-lsp-booster' integration and a cape-aware
;; `completion-at-point' hook), lsp-ui, consult-lsp, flycheck, the
;; yasnippet runtime, and envrc.

;;; Code:

(require 'elementary-emacs-keys)

(use-package envrc
  :demand t
  :hook (after-init . envrc-global-mode))

(use-package flycheck
  :hook (after-init . global-flycheck-mode)
  :custom
  (flycheck-indication-mode 'right-fringe))

(use-package yasnippet
  :defer t)

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

  ;; NOTE: see https://github.com/blahgeek/emacs-lsp-booster?tab=readme-ov-file#configure-lsp-mode
  (defun lsp-booster--advice-json-parse (old-fn &rest args)
    "Try to parse bytecode instead of json."
    (or
     (when (equal (following-char) ?#)
       (let ((bytecode (read (current-buffer))))
         (when (byte-code-function-p bytecode)
           (funcall bytecode))))
     (apply old-fn args)))
  (advice-add (if (progn (require 'json)
                         (fboundp 'json-parse-buffer))
                  'json-parse-buffer
                'json-read)
              :around
              #'lsp-booster--advice-json-parse)

  (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
    "Prepend emacs-lsp-booster command to lsp CMD."
    (let ((orig-result (funcall old-fn cmd test?)))
      (if (and (not test?)                             ;; for check lsp-server-present?
               (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
               ;; Disable for `jdtls' since it doesn't conform to the LSP spec and breaks `emacs-lsp-booster'
               ;; FIXME: remove when https://github.com/eclipse-jdtls/eclipse.jdt.ls/issues/3338 is resolved
               (-none? (lambda (argv) (string-match ".*jdtls.*" argv)) orig-result)
               lsp-use-plists
               (not (functionp 'json-rpc-connection))  ;; native json-rpc
               (executable-find "emacs-lsp-booster"))
          (progn
            (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
              (setcar orig-result command-from-exec-path))
            (message "Using emacs-lsp-booster for %s!" orig-result)
            (cons "emacs-lsp-booster" orig-result))
        orig-result)))

  (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

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
  (lsp-mode . yas-minor-mode)
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
