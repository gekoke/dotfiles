;;; elementary-emacs-editor.el --- Editing experience -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (editorconfig "0.11") (evil "1.15") (evil-anzu "0.1") (evil-collection "0.1") (evil-matchit "3.0") (evil-mc "0.1") (evil-numbers "0.7") (evil-surround "1.1") (evil-textobj-tree-sitter "0.1") (general "0.1") (helpful "0.21") (indent-bars "0.8") (jinx "1.5") (link-hint "0.2") (treesit-auto "0.4") (undo-tree "0.7") (elementary-emacs-keys "0.1"))
;; Keywords: convenience

;;; Commentary:

;; Editing experience for Elementary Emacs: editorconfig support,
;; the full evil suite (collection, anzu, numbers, surround, matchit,
;; multi-cursors, tree-sitter text objects), jinx for spell-check,
;; helpful for richer documentation buffers, link-hint for
;; keyboard-driven link navigation, relative line numbers and
;; `hl-line-mode' for code buffers, indent bars, and whitespace
;; visualization.  Also defines a few global buffer-management
;; leaders.

;;; Code:

(require 'elementary-emacs-keys)

(setq display-line-numbers-type 'relative)
(column-number-mode)

(defun elementary-emacs-editor--enable-line-numbers ()
  "Enable relative `display-line-numbers-mode' in the current buffer."
  (display-line-numbers-mode 1))

(defun elementary-emacs-editor--enable-hl-line ()
  "Enable `hl-line-mode' in the current buffer."
  (hl-line-mode 1))

(dolist (hook '(prog-mode-hook
                conf-mode-hook
                json-ts-mode-hook
                text-mode-hook))
  (add-hook hook #'elementary-emacs-editor--enable-line-numbers)
  (add-hook hook #'elementary-emacs-editor--enable-hl-line))

(use-package editorconfig
  :hook (after-init . editorconfig-mode))

(use-package treesit-auto
  :hook (after-init . global-treesit-auto-mode)
  :config
  (delete 'rust treesit-auto-langs) ;; conflicts with mode set up by rustic-mode config
  (delete 'c-sharp treesit-auto-langs)) ;; sucks

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

(use-package whitespace
  :defer t
  :init
  (define-global-minor-mode gg/global-whitespace-mode whitespace-mode
    (lambda ()
      (when (derived-mode-p
             'prog-mode
             'yaml-mode
             'markdown-mode)
        (whitespace-mode))))
  :custom
  (whitespace-display-mappings
   '((space-mark 32
                [183]
                [46])
    (space-mark 160
                [164]
                [95])
    (newline-mark 10
                  [8629 10])
    (tab-mark 9
              [187 9]
              [92 9])))
  (whitespace-style
   '(face tabs spaces trailing space-before-tab indentation empty space-after-tab space-mark tab-mark))
  :general
  (gg/leader
    "e w" #'gg/global-whitespace-mode))

(use-package indent-bars
  :demand t
  :hook (after-init . gg/global-indent-bars-mode)
  :init
  (define-global-minor-mode gg/global-indent-bars-mode indent-bars-mode
    (lambda ()
      (when (and (not (derived-mode-p 'emacs-lisp-mode))
                 (derived-mode-p
                  'prog-mode
                  'yaml-mode
                  'markdown-mode))
        (let ((max-lisp-eval-depth (expt 2 14)))
          (indent-bars-mode)))))
  :config
  (require 'indent-bars-ts)
  :custom
  (indent-bars-pattern ".")
  (indent-bars-highlight-current-depth '(:face default :blend 0.4))
  (indent-bars-width-frac 0.1)
  (indent-bars-pad-frac 0.1)
  (indent-bars-zigzag nil)
  (indent-bars-color-by-depth nil)

  (indent-bars-display-on-blank-lines t)
  (indent-bars-starting-column 0)
  (indent-bars-treesit-support t)
  :general
  (gg/leader
    "e i" #'gg/global-indent-bars-mode))

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default truncate-lines t)

(electric-indent-mode +1)
(electric-pair-mode +1)

(defun elementary-emacs-editor--enable-hs-minor ()
  "Enable `hs-minor-mode' in the current buffer."
  (hs-minor-mode 1))

(dolist (hook '(prog-mode-hook
                conf-mode-hook
                json-ts-mode-hook))
  (add-hook hook #'elementary-emacs-editor--enable-hs-minor))

(provide 'elementary-emacs-editor)
;;; elementary-emacs-editor.el ends here
