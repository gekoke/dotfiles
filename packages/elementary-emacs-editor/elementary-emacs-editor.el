;;; elementary-emacs-editor.el --- Editing experience -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (editorconfig "0.11") (evil "1.15") (evil-anzu "0.1") (evil-collection "0.1") (evil-matchit "3.0") (evil-mc "0.1") (evil-numbers "0.7") (evil-surround "1.1") (evil-textobj-tree-sitter "0.1") (general "0.1") (helpful "0.21") (jinx "1.5") (link-hint "0.2") (undo-tree "0.7") (elementary-emacs-keys "0.1"))
;; Keywords: convenience

;;; Commentary:

;; Editing experience for Elementary Emacs: editorconfig support,
;; the full evil suite (collection, anzu, numbers, surround, matchit,
;; multi-cursors, tree-sitter text objects), jinx for spell-check,
;; helpful for richer documentation buffers, and link-hint for
;; keyboard-driven link navigation.  Also defines a few global
;; buffer-management leaders.

;;; Code:

(require 'elementary-emacs-keys)

(use-package editorconfig
  :hook (after-init . editorconfig-mode))

(use-package text-mode
  :defer t
  :custom
  (text-mode-ispell-word-completion nil))

(use-package emacs
  :general
  (gg/leader
    "i" #'ibuffer
    "B r" #'rename-buffer
    "s" #'save-buffer))

(general-def
  "C-s" #'avy-goto-char-2)

(use-package jinx
  :hook (text-mode . jinx-mode))

(use-package evil
  :hook (after-init . evil-mode)
  :init
  (add-hook 'wdired-mode-hook #'turn-on-undo-tree-mode)
  :bind
  (:repeat-map evil-window-resizing-repeat-map
               ("-" . evil-window-decrease-height)
               ("+" . evil-window-increase-height)
               (">" . evil-window-increase-width)
               ("<" . evil-window-decrease-width))
  :custom
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-want-minibuffer t)
  (evil-undo-system 'undo-tree)
  :config
  (add-to-list 'evil-jumps-ignored-file-patterns ".*/$")
  :general
  (general-def
    :states '(motion)
    "C-w u" #'winner-undo
    "C-w C-u" #'winner-undo
    "C-w i" #'winner-redo
    "C-w C-i" #'winner-redo))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-magit-use-z-for-folds t)
  (magit-diff-refine-hunk t)
  (magit-diff-refine-ignore-whitespace nil)
  (magit-status-margin '(t age magit-log-margin-width t 18))
  :config
  (evil-collection-init))

(use-package evil-anzu
  :hook (evil-mode . global-anzu-mode))

(use-package evil-numbers
  :after evil
  :general
  (general-def
    :states '(normal visual)
    "C-a" #'evil-numbers/inc-at-pt
    "C-x" #'evil-numbers/dec-at-pt)
  (general-def
    :states 'visual
    "g C-a" #'evil-numbers/inc-at-pt-incremental
    "g C-x" #'evil-numbers/dec-at-pt-incremental))

(use-package evil-surround
  :hook (evil-mode . global-evil-surround-mode))

(use-package evil-matchit
  :hook (evil-mode . global-evil-matchit-mode))

(use-package evil-mc
  :hook (evil-mode . global-evil-mc-mode)
  :general
  (general-def
    :states 'normal
    "C-M-j" #'evil-mc-make-cursor-move-next-line
    "C-M-k" #'evil-mc-make-cursor-move-prev-line
    "C-S-j" #'evil-mc-make-and-goto-next-match
    "C-S-k" #'evil-mc-make-and-goto-prev-match))

(use-package evil-textobj-tree-sitter
  :after evil
  :general
  (general-def
    :keymaps 'evil-outer-text-objects-map
    "f" (evil-textobj-tree-sitter-get-textobj "function.outer"))
  (general-def
    :keymaps 'evil-inner-text-objects-map
    "f" (evil-textobj-tree-sitter-get-textobj "function.inner")))

(use-package link-hint
  :general
  (gg/leader
    "L o" #'link-hint-open-link
    "L c" #'link-hint-copy-link))

(use-package helpful
  :init
  (add-to-list 'display-buffer-alist
               '("\\*helpful"
                 (display-buffer-same-window)))
  :custom
  (help-window-select t)
  :general
  (gg/leader
    "h p" #'helpful-at-point
    "h f" #'helpful-function
    "h a" #'helpful-callable
    "h v" #'helpful-variable
    "h k" #'helpful-key
    "h c" #'helpful-command
    "h m" #'describe-mode))

(provide 'elementary-emacs-editor)
;;; elementary-emacs-editor.el ends here
