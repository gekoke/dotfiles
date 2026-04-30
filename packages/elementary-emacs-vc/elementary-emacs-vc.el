;;; elementary-emacs-vc.el --- Version control integration -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (diff-hl "1.10") (forge "0.4") (general "0.1") (hl-todo "3.7") (magit "4.3") (magit-todos "1.7") (elementary-emacs-keys "0.1"))
;; Keywords: vc, tools

;;; Commentary:

;; Version control bundle for Elementary Emacs: magit (with auto-fetch
;; advice and a custom transient suffix for tag messages), forge for
;; GitHub integration, magit-todos, hl-todo, and diff-hl with flydiff.
;; Also normalizes ediff to plain windows.

;;; Code:

(require 'elementary-emacs-keys)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package magit
  :defer t
  :custom
  (magit-format-file-function #'magit-format-file-nerd-icons)
  (magit-no-confirm '(set-and-push stage-all-changes unstage-all-changes))
  (magit-commit-squash-confirm nil)
  (magit-bury-buffer-function #'magit-restore-window-configuration)
  (magit-revision-show-gravatars t)
  (magit-diff-fontify-hunk 'all)
  :config
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (defun gg/magit-auto-fetch ()
    (interactive)
    (magit-fetch-all ())
    (when (forge-buffer-repository)
      (forge-pull)))
  (advice-add 'magit-status :after #'gg/magit-auto-fetch)
  :general
  (gg/leader
    "v" #'magit-status
    "V" #'magit-status-here
    "g i" #'magit-init))

(use-package magit-todos
  :hook (magit-mode . magit-todos-mode))

(use-package transient
  :after magit
  :config
  (transient-define-argument magit-tag:--message ()
    :description "Use message"
    :class 'transient-option
    :shortarg "-m"
    :argument "--message="
    :allow-empty t)
  (transient-append-suffix
    'magit-tag
    "-u"
    '(magit-tag:--message)))

(use-package forge
  :after magit
  :custom
  (forge-add-default-bindings nil)
  (forge-owned-accounts '(("gekoke")))
  :config
  (add-to-list 'forge-alist '("ssh.github.com" "api.github.com" "github.com" forge-github-repository)))

(use-package diff-hl
  :hook
  (after-init . global-diff-hl-mode)
  :custom
  (diff-hl-show-staged-changes nil)
  (diff-hl-ask-before-revert-hunk nil)
  (diff-hl-draw-borders nil)
  :general
  (gg/leader
    "g" '(:ignore t :which-key "VC")
    "g s" #'diff-hl-stage-current-hunk
    "g r" #'diff-hl-revert-hunk
    "g h" #'diff-hl-show-hunk))

(use-package diff-hl-flydiff
  :hook (after-init . diff-hl-flydiff-mode))

(use-package hl-todo
  :defer t)

(provide 'elementary-emacs-vc)
;;; elementary-emacs-vc.el ends here
