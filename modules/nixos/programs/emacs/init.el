(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(setq use-package-always-ensure t)
(setq use-package-always-demand t)

(setq-default tab-width 4)

(use-package org
  :custom
  (org-capture-templates
   '(("t" "Todo" entry (file+headline "~/Documents/Org/todo.org" "Tasks")
      "* TODO %?\n")
     ("n" "Note" entry (file+headline "~/Documents/Org/notes.org" "Notes")
      "*%?\n")))
  (org-default-notes-file "~/Documents/Org/misc.org")
  (org-agenda-files '("~/Documents/Org/")))

(use-package time
  :ensure nil
  :init
  (display-time-mode)
  :custom
  (display-time-24hr-format t)
  (display-time-default-load-average nil))

(use-package calendar
  :ensure nil
  :custom
  (calendar-week-start-day 1))

(use-package general
  :config
  (general-create-definer gg/leader
    :states '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (general-create-definer gg/local
    :states '(normal insert visual emacs)
    :prefix "SPC m"
    :global-prefix "C-SPC m"))

(use-package emacs
  :ensure nil
  :general
  (gg/leader
    "B r" #'rename-buffer))

(use-package undo-tree
  :custom
  (undo-tree-enable-undo-in-region t)
  (undo-tree-history-directory-alist `(("." . ,(concat user-emacs-directory "undo-tree-history")))))

(let ((backup-dir "~/.local/state/emacs/backups")
      (auto-saves-dir "~/.local/state/emacs/autosaves"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 8    ; keep some new versions
      kept-old-versions 8)   ; and some old ones, too

(setq create-lockfiles nil)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-message t)
(setq use-dialog-box nil)
(setq native-comp-async-report-warnings-errors nil)
(setq initial-scratch-message "")
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(save-place-mode 1)
(setq-default cursor-in-non-selected-windows nil)
(recentf-mode 1)
(savehist-mode 1)
(global-auto-revert-mode 1)
(column-number-mode)
(setq-default left-fringe-width 4)
(setq-default right-fringe-width 12)

(setq display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook (lambda () (display-line-numbers-mode 1)))
(add-hook 'conf-mode-hook (lambda () (display-line-numbers-mode 1)))
(add-hook 'json-ts-mode-hook (lambda () (display-line-numbers-mode 1)))
(add-hook 'text-mode-hook (lambda () (display-line-numbers-mode 1)))

(add-hook 'prog-mode-hook (lambda () (hl-line-mode 1)))
(add-hook 'conf-mode-hook (lambda () (hl-line-mode 1)))
(add-hook 'json-ts-mode-hook (lambda () (hl-line-mode 1)))
(add-hook 'text-mode-hook (lambda () (hl-line-mode 1)))

(add-hook 'prog-mode-hook (lambda () (hs-minor-mode 1)))
(add-hook 'conf-mode-hook (lambda () (hs-minor-mode 1)))
(add-hook 'json-ts-mode-hook (lambda () (hs-minor-mode 1)))

(electric-indent-mode +1)
(electric-pair-mode +1)
(setq-default indent-tabs-mode nil)
(setq-default truncate-lines t)
(show-paren-mode 1)

(setq even-window-sizes nil)

(use-package ace-window
  :ensure t
  :general
  (general-def
    :states '(motion)
    "C-w w" #'ace-window
    "C-w C-w" #'ace-window
    "C-w e" #'ace-swap-window
    "C-w C-e" #'ace-swap-window
    "C-w d" #'ace-delete-window
    "C-w C-d" #'ace-delete-window))

(add-to-list 'display-buffer-alist
            '("\\*compilation*"
              nil
              (reusable-frames . t)))

(use-package eyebrowse
  :init
  (eyebrowse-mode 1)
  :custom
  (eyebrowse-new-workspace #'dashboard-open)
  (eyebrowse-mode-line-separator "|")
  :general
  (with-eval-after-load 'magit
    (general-def
      :states 'normal
      :keymaps 'magit-section-mode-map
      "C-<tab>" #'eyebrowse-last-window-config))
  (general-def
    :keymaps 'override
    "C-<tab>" #'eyebrowse-last-window-config)
  (gg/leader
    "<tab> d" #'eyebrowse-close-window-config
    "<tab> m" #'eyebrowse-move-window-config
    "0" #'eyebrowse-switch-to-window-config-0
    "1" #'eyebrowse-switch-to-window-config-1
    "2" #'eyebrowse-switch-to-window-config-2
    "3" #'eyebrowse-switch-to-window-config-3
    "4" #'eyebrowse-switch-to-window-config-4
    "5" #'eyebrowse-switch-to-window-config-5
    "6" #'eyebrowse-switch-to-window-config-6
    "7" #'eyebrowse-switch-to-window-config-7
    "8" #'eyebrowse-switch-to-window-config-8
    "9" #'eyebrowse-switch-to-window-config-9))

(use-package indent-bars
  :ensure nil
  :config
  (require 'indent-bars-ts)
  :custom
  (indent-bars-pattern ".")
  (indent-bars-highlight-current-depth '(:face default :blend 0.4))
  (indent-bars-width-frac 0.1)
  (indent-bars-pad-frac 0.1)
  (indent-bars-zigzag nil)
  (indent-bars-color-by-depth nil)

  (indent-bars-display-on-blank-lines nil)
  (indent-bars-starting-column 0)
  (indent-bars-treesit-support t))

(use-package jinx
  :ensure t
  :hook (emacs-startup . global-jinx-mode))

(use-package whitespace
  :ensure nil
  :init
  (define-global-minor-mode gg/global-whitespace-mode whitespace-mode
    (lambda ()
      (when (derived-mode-p 'prog-mode)
        (whitespace-mode))))
  (gg/global-whitespace-mode)
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

;; TODO: serialize to file
(defun gg/set-background-opacity (opacity)
  "Interactively change the current frame's OPACITY."
  (interactive
   (list (read-number "Opacity (0-100): "
                      (or (frame-parameter nil 'alpha)
                          100))))
  (set-frame-parameter nil 'alpha-background opacity))

(gg/leader
  "t o" #'gg/set-background-opacity)

(use-package nerd-icons)

(use-package package-lint)

(dolist (assoc '(("age" nerd-icons-codicon "nf-cod-gist_secret" :face nil)
                 ("apk" nerd-icons-devicon "nf-dev-android" :face nerd-icons-green)
                 ("chs" nerd-icons-devicon "nf-dev-haskell" :face nerd-icons-purple)
                 ("css" nerd-icons-devicon "nf-dev-css3" :face nerd-icons-blue)
                 ("hs" nerd-icons-devicon "nf-dev-haskell" :face nerd-icons-purple)
                 ("hsc" nerd-icons-devicon "nf-dev-haskell" :face nerd-icons-purple)
                 ("ico" nerd-icons-sucicon "nf-seti-favicon" :face nerd-icons-yellow)
                 ("jar" nerd-icons-devicon "nf-dev-java" :face nerd-icons-red)
                 ("java" nerd-icons-devicon "nf-dev-java" :face nerd-icons-red)
                 ("json" nerd-icons-codicon "nf-cod-json" :face nerd-icons-yellow)
                 ("lhs" nerd-icons-devicon "nf-dev-haskell" :face nerd-icons-purple)
                 ("lock" nerd-icons-faicon "nf-fa-lock" :face nerd-icons-yellow)
                 ("pdf" nerd-icons-faicon "nf-fa-file_pdf_o" :face nerd-icons-red)
                 ("svg" nerd-icons-mdicon "nf-md-svg" :face nerd-icons-yellow)
                 ("ts" nerd-icons-sucicon "nf-seti-typescript" :face nerd-icons-blue)
                 ("toml" nerd-icons-sucicon "nf-seti-typescript" :face nerd-icons-blue)
                 ("txt" nerd-icons-sucicon "nf-seti-text" :face nerd-icons-silver)
                 ("yaml" nerd-icons-sucicon "nf-seti-yml" :face nerd-icons-purple)
                 ("yml" nerd-icons-sucicon "nf-seti-yml" :face nerd-icons-purple)))
  (add-to-list 'nerd-icons-extension-icon-alist assoc))

(dolist (regexp '("^TAGS$"
                  "^TODO$"
                  "^LICENSE$"
                  "^readme"))
  (setf nerd-icons-regexp-icon-alist (assoc-delete-all regexp nerd-icons-regexp-icon-alist)))

(use-package doom-modeline
  :after nerd-icons
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 32)
  (doom-modeline-indent-info t)
  (doom-modeline-modal-icon nil)
  (doom-modeline-check-icon nil)
  (doom-modeline-buffer-state-icon nil)
  (doom-modeline-workspace-name nil)
  (doom-modeline-buffer-file-name-style 'file-name-with-project))

(use-package nyan-mode
  :after doom-modeline
  :init
  (nyan-mode 1)
  :custom
  (nyan-animation-frame-interval (/ 1.0 20)))

(use-package dashboard
  :after (consult nerd-icons)
  :init
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-set-init-info t)
  (dashboard-center-content t)

  (dashboard-icon-type 'nerd-icons)
  (dashboard-display-icons-p t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)

  (dashboard-items '())
  :config
  (dashboard-setup-startup-hook))

(setq custom-safe-themes t)
(use-package doom-themes)
(use-package vscode-dark-plus-theme)
(use-package ef-themes)
(use-package apropospriate-theme)
(use-package adwaita-dark-theme :ensure nil)
(use-package gruvbox-theme)
(use-package modus-themes)
(use-package catppuccin-theme
  :custom
  (catppuccin-flavor 'frappe))
(use-package anisochromatic :ensure nil)
(use-package miasma-theme :ensure nil)

(use-package remember-last-theme
  :config
  (remember-last-theme-enable))

(set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 110 :weight 'medium)

(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ">>=" ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++")))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package olivetti
  :custom
  (olivetti-body-width 140)
  :general
  (gg/leader
    "t c" 'olivetti-mode))

(use-package which-key
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.4))

(use-package rg)
(use-package wgrep)

(use-package embark
  :general
  (general-def
    "M-e" #'embark-export))
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  (vertico-cycle t))

(use-package marginalia
  :init
  ;; Marginalia must be actived in the :init section
  (marginalia-mode)
  :general
  (general-def minibuffer-local-map "M-A" #'marginalia-cycle))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :after remember-last-theme
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  :config
  (defun gg/consult-theme-and-remember ()
    "Run consult-theme and remember the last theme used"
    (interactive)
    (call-interactively 'consult-theme)
    (let ((inhibit-message t)
          (message-log-max nil))
      (remember-last-theme-save)))
  :general
  (gg/leader
    "t" '(:ignore t :which-key "Theme")
    "t h" #'gg/consult-theme-and-remember
    "/" #'consult-ripgrep))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

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

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(winner-mode +1)

(repeat-mode +1)

(general-def
  "C-s" #'avy-goto-char)

(use-package evil
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
  (evil-mode 1)
  (add-to-list 'evil-jumps-ignored-file-patterns ".*/$")
  :general
  (gg/leader
    "s" #'save-buffer)
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
  (magit-diff-refine-hunk 'all)
  (magit-status-margin '(t age magit-log-margin-width t 18))
  :config
  (evil-collection-init))

(use-package evil-anzu
  :after evil
  :init
  (global-anzu-mode))

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
  :config
  (global-evil-surround-mode 1))

(use-package evil-matchit
  :init
  (global-evil-matchit-mode 1))

(use-package evil-mc
  :init
  (global-evil-mc-mode 1)
  :general
  (general-def
    :states 'normal
    "C-M-j" #'evil-mc-make-cursor-move-next-line
    "C-M-k" #'evil-mc-make-cursor-move-prev-line
    "C-S-j" #'evil-mc-make-and-goto-next-match
    "C-S-k" #'evil-mc-make-and-goto-prev-match))

(use-package evil-textobj-tree-sitter
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

(use-package pdf-tools
  :init
  (pdf-tools-install))

(use-package dirvish
  :after nerd-icons
  :init
  (dirvish-override-dired-mode)
  (dirvish-side-follow-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   `(("h" "~/"                                     "Home")
     ("d" "~/Documents/"                           "Documents")
     ("l" "~/Downloads/"                           "Downloads")
     ("p" "~/Pictures"                             "Pictures")
     ("t" "~/.local/share/Trash/files/"            "Trash")
     ("r" "/"                                      "/")
     ("m"  ,(concat "/run/media/" user-login-name) "Removable Media")))

  (dirvish-emerge-groups
   '(("Recent files" (predicate . recent-files-2h))
     ("Documents" (extensions "pdf" "tex" "bib" "epub"))
     ("Video" (extensions "mp4" "mkv" "webm"))
     ("Pictures" (extensions "jpg" "png" "svg" "gif" "webp"))
     ("Audio" (extensions "mp3" "flac" "wav" "ape" "aac"))
     ("Archives" (extensions "gz" "rar" "zip"))))

  (dirvish-mode-line-format '(:left (sort symlink omit) :right (vc-info yank index)))
  (dirvish-header-line-format '(:left (path) :right (free-space)))
  (dirvish-path-separators (list "   " "   " "  "))

  (delete-by-moving-to-trash t)

  (dirvish-show-media-properties t)
  (dirvish-media-auto-cache-threshold '(500 . 8))

  (dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")

  (dired-mouse-drag-files t)
  (mouse-drag-and-drop-region-cross-program t)

  (dirvish-attributes
            '(nerd-icons file-time subtree-state vc-state git-msg))
  :general
  (general-def
    :states 'normal
    :keymaps 'dirvish-mode-map
    "q"    #'dirvish-quit
    "h"    #'dired-up-directory ; remapped `describe-mode'
    "l"    #'dired-find-file
    "a"    #'dirvish-quick-access
    "f"    #'dirvish-file-info-menu
    "y"    #'dirvish-yank-menu
    "^"    #'dirvish-history-last
    "$"    #'dirvish-history-jump
    "s"    #'dirvish-quicksort  ; remapped `dired-sort-toggle-or-edit'
    "v"    #'dirvish-vc-menu    ; remapped `dired-view-file'
    "."    #'dired-omit-mode    ; remapped `dired-clean-directory'
    "RET"  #'dirvish-subtree-toggle-or-open
    "<tab>" #'dirvish-subtree-toggle
    "M-l"  #'dirvish-ls-switches-menu
    "M-m"  #'dirvish-mark-menu
    "M-n"  #'dirvish-narrow
    "M-t"  #'dirvish-layout-toggle
    "M-s"  #'dirvish-setup-menu
    "M-e"  #'dirvish-emerge-menu
    "M-j"  #'dirvish-fd-jump
    "C-i"  #'dirvish-history-go-forward
    "C-o"  #'dirvish-history-go-backward)
  (gg/leader
    "d" #'dirvish)
  (gg/local
    :keymaps 'dirvish-mode-map
    "d" #'dirvish-fd
    "i" #'dired-gitignore-mode
    "g" #'dirvish-emerge-mode
    "f" #'dired-create-empty-file
    "k" #'dired-create-directory))

(use-package dired-x
  :ensure nil
  :config
  ;; Make dired-omit-mode hide all "dotfiles"
  (setq dired-omit-files
        (concat dired-omit-files "\\|^\\..*$")))

(use-package diredfl
  :hook
  (dired-mode . diredfl-mode)
  (dirvish-directory-view-mode . diredfl-mode)
  :config
  (set-face-attribute 'diredfl-dir-name nil :bold t))

(use-package dired
  :ensure nil
  :init
  (setq dired-deletion-confirmer #'(lambda (_) t)))

(use-package dired-gitignore)

(use-package cape
  :init
  (setq-default completion-at-point-functions (list
                                               #'cape-file
                                               #'cape-dabbrev
                                               #'cape-keyword))
  (defun gg/setup-elisp-mode-capf ()
    (setq-local completion-at-point-functions (list
                                               (cape-capf-nonexclusive #'elisp-completion-at-point)
                                               #'cape-file
                                               #'cape-dabbrev
                                               #'cape-keyword)))
  :hook
  (emacs-lisp-mode . gg/setup-elisp-mode-capf))

(use-package corfu
  :custom
  (completion-ignore-case t)
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-delay (/ 1.0 60))
  (corfu-auto-prefix 1)
  (corfu-popupinfo-mode t)
  (corfu-min-width 30)
  (corfu-popupinfo-delay '(0 . 0))
  :init
  (global-corfu-mode))

(use-package emacs
  :after corfu
  :custom
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete))

(use-package nerd-icons-corfu
  :after corfu
  :init
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package vterm
  :init
  (add-to-list 'display-buffer-alist
               '("\\*vterm*"
                 (display-buffer-at-bottom))))
(use-package vterm-toggle
  :init
  (defun gg/vterm-new ()
    (interactive)
    (vterm-toggle--new))
  :general
  (gg/leader
    "o o" #'vterm-toggle-cd
    "o n" #'gg/vterm-new
    "o j" #'vterm-toggle-forward
    "o k" #'vterm-toggle-backward))

;; Don't make new frame for ediff - why would I want that?!
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package magit-file-icons
  :after magit
  :config
  (magit-file-icons-mode))

(use-package magit
  :hook (magit-log-mode . magit-diff-show-or-scroll-up)
  :init
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (defun gg/magit-auto-fetch ()
    (interactive)
    (magit-fetch-all ())
    (when (forge-buffer-repository)
      (forge-pull)))
  (advice-add 'magit-status :after #'gg/magit-auto-fetch)
  :custom
  (magit-no-confirm '(set-and-push stage-all-changes unstage-all-changes))
  (magit-bury-buffer-function #'magit-restore-window-configuration)
  (magit-revision-show-gravatars t)
  (magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
  :general
  (gg/leader
    "v" #'magit-status
    "V" #'magit-status-here
    "g i" #'magit-init)
  (general-def
    :states '(normal visual)
    :keymaps 'magit-log-mode-map
    "k" #'magit-section-backward-sibling
    "j" #'magit-section-forward-sibling))

(use-package forge
  :after magit
  :custom
  (forge-add-default-bindings nil) ;; Use evil-collection instead
  (forge-owned-accounts '(("gekoke")))
  :config
  (add-to-list 'forge-alist '("ssh.github.com" "api.github.com" "github.com" forge-github-repository)))

(use-package diff-hl
  :custom
  (diff-hl-show-staged-changes nil)
  (diff-hl-ask-before-revert-hunk nil)
  (diff-hl-draw-borders nil)
  :init
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)
  :general
  (gg/leader
    "g" '(:ignore t :which-key "VC")
    "g s" #'diff-hl-stage-current-hunk
    "g r" #'diff-hl-revert-hunk
    "g h" #'diff-hl-show-hunk))

(use-package blamer
  :custom
  (blamer-idle-time 0.25)
  (blamer-min-offset 60)
  (blamer-max-commit-message-length 120)
  :custom-face
  (blamer-face ((t :background nil
                   :weight normal
                   :italic nil))))

(use-package hl-todo
  :config
  (global-hl-todo-mode))

(use-package projectile
  :init
  (projectile-mode +1)
  :custom
  (projectile-track-known-projects-automatically nil)
  :general
  (gg/leader
    "p" '(:keymap projectile-command-map :which-key "Project")
    "r r" #'projectile-repeat-last-command)
  (general-def projectile-command-map
    "a" #'projectile-add-known-project
    "A" #'projectile-find-other-file))

(use-package consult-projectile
  :general
  (gg/leader
    "SPC" #'consult-projectile
    "C-SPC" #'consult-projectile
    "B p" #'consult-projectile-switch-to-buffer
    "b" #'consult-buffer)
  (general-def projectile-command-map
    "p" #'consult-projectile-switch-project))

(use-package envrc
  :config
  (envrc-global-mode))

(use-package flycheck
  :init
  (global-flycheck-mode)
  :custom
  (flycheck-indication-mode 'right-fringe))

(use-package treesit-auto
  :config
  (delete 'yaml treesit-auto-langs) ;; yaml-mode is superior
  (delete 'rust treesit-auto-langs) ;; conflicts with mode set up by rustic-mode config
  (global-treesit-auto-mode))

(use-package yasnippet)

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-idle-delay 0)
  (eldoc-display-functions '(eldoc-display-in-buffer))
  :general
  (general-def
    :states '(normal)
    "g h" #'eldoc))

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
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  (lsp-mode . yas-minor-mode)
  (lsp-completion-mode . gg/setup-lsp-mode-capf)
  :custom
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-eldoc-render-all t)
  (lsp-inlay-hint-enable t)
  (lsp-semantic-tokens-enable t)
  :config
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("emmet-language-server" "--stdio"))
    :activation-fn (lsp-activate-on "html" "css" "scss" "less" "javascriptreact" "typescriptreact")
    :priority -1
    :add-on? t
    :multi-root t
    :server-id 'emmet-language-server))
  :general
  (gg/leader lsp-mode-map
    "l" '(:keymap lsp-command-map))
  (general-def lsp-command-map
    "= r" #'lsp-format-region))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-sideline-diagnostic-max-line-length 280))

(use-package consult-lsp
  :after lsp-mode
  :general
  (general-def lsp-command-map
    "s s" #'consult-lsp-symbols
    "s f" #'consult-lsp-file-symbols
    "s d" #'consult-lsp-diagnostics))

(use-package lsp-nix
  :ensure lsp-mode
  :after lsp-mode
  :custom
  (lsp-nix-nil-formatter ["nixfmt"]))

(use-package nix-ts-mode
  :mode "\\.nix\\'"
  :hook (nix-ts-mode . lsp-deferred))

(use-package lsp-pyright
  :hook (python-ts-mode . (lambda ()
                            (require 'lsp-pyright)
                            (lsp)))
  :custom
  (lsp-pyright-venv-directory "./.venv"))

(use-package lsp-ruff
  :ensure lsp-mode
  :after lsp-mode)

(use-package python
  :ensure nil
  :init
  ;; TODO: make this the same as `gg/global-whitespace-mode' for LSP buffers
  (add-hook 'before-save-hook (lambda ()
                                (when (and
                                       (eq major-mode 'python-ts-mode)
                                       (bound-and-true-p lsp-mode))
                                  (lsp-format-buffer)))))

(use-package lsp-java
  :init
  :hook (java-ts-mode . (lambda ()
                          (load "lsp-java.el")
                          (lsp))))

(use-package rustic
  :ensure t
  :mode
  ("\\.rs\\'" . rustic-mode)
  :custom
  (rustic-format-trigger t))

(use-package lsp-rust
  :ensure lsp-mode
  :custom
  (lsp-rust-analyzer-lens-references-adt-enable t)
  (lsp-rust-analyzer-lens-references-trait-enable t)
  (lsp-rust-analyzer-lens-references-enum-variant-enable t)
  (lsp-rust-analyzer-max-inlay-hint-length 15)
  (lsp-rust-analyzer-diagnostics-enable-experimental t)
  (lsp-rust-clippy-preference "on"))

(use-package markdown-mode
  :custom
  (markdown-fontify-code-blocks-natively t)
  :config
  (add-to-list 'markdown-code-lang-modes '("py" . python-mode))
  (add-to-list 'markdown-code-lang-modes '("python" . python-mode)))

(use-package web-mode
  :hook
  (web-mode . lsp)
  (web-mode . (lambda ()
                (progn
                  (require 'sgml-mode)
                  (sgml-electric-tag-pair-mode))))
  :init
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-hook 'web-mode-hook (lambda () (electric-pair-local-mode -1)))
  :custom
  (web-mode-script-padding 4)
  (web-mode-enable-auto-pairing t)
  (web-mode-enable-auto-opening t)
  (web-mode-enable-auto-quoting t))

(use-package lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t))

(use-package typescript-ts-mode
  :ensure nil
  :mode
  ("\\.ts\\'" . typescript-ts-mode)
  ("\\.tsx\\'" . tsx-ts-mode)
  :hook
  (typescript-ts-mode . lsp)
  (tsx-ts-mode . lsp))

(use-package lsp-javascript
  :ensure nil
  :custom
  (lsp-typescript-references-code-lens-enabled t)
  (lsp-typescript-implementations-code-lens-enabled t))

(use-package js
  :ensure nil
  :hook
  (js-ts-mode . lsp)
  :mode
  ("\\.mjs\\'" . js-ts-mode)
  ("\\.js\\'" . js-ts-mode))

(use-package emacs
  :ensure nil
  :hook
  (csharp-mode . lsp)
  (csharp-ts-mode . lsp))

(use-package emacs
  :ensure nil
  :mode
  ("\\(Containerfile\\|Dockerfile\\).*" . dockerfile-ts-mode))

(use-package yaml-mode
  :hook (yaml-mode . lsp)
  :mode ("\\.\\(yml\\|yaml\\)\\'"))

(use-package terraform-mode)

(use-package feature-mode)

(use-package lsp-mode
  :custom
  (lsp-go-analyses '((shadow . t)
                     (simplifycompositelit . :json-false))))

(use-package go-ts-mode
  :ensure nil
  :custom
  (go-ts-mode-indent-offset tab-width))

(use-package typst-ts-mode
  :ensure nil
  :custom
  (typst-ts-mode-indent-offset 2))

(use-package lsp-mode
  :init
  (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
  :config
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "typst-lsp")
    :activation-fn (lsp-activate-on "typst")
    :server-id 'typst-lsp)))

(use-package age
  :custom
  (age-program "rage")
  (age-default-identity "~/.ssh/id_ed25519")
  (age-default-recipient "~/.ssh/id_ed25519.pub")
  :config
  (age-file-enable))

(use-package hackernews)

(general-def
  "C--" #'text-scale-decrease
  "C-=" #'text-scale-increase)

(gg/leader
  :keymaps 'smerge-mode-map
  "m" '(:ignore t :which-key "Merge")
  "m p" #'smerge-prev
  "m n" #'smerge-next
  "m u" #'smerge-keep-upper
  "m l" #'smerge-keep-lower
  "m t" #'smerge-keep-current
  "m a" #'smerge-keep-all)

(gg/leader
  "." #'find-file
  "x" #'kill-current-buffer
  "z" #'bury-buffer
  "E b" #'eval-buffer
  "E r" #'eval-region
  "r" '(:ignore t :which-key "Regex")
  "r l" #'align-regexp)

(defun gg/hex-to-decimal (hex)
  "Convert the base-16 integer represented by string HEX to decimal."
  (interactive "MHex: ")
  (shell-command (format "echo $((16#%s))" hex)))

(defun gg/weather ()
  "Show the weather"
  (interactive)
  (async-shell-command "curl 'wttr.in?M'"))

(gg/leader
  "u w" #'gg/weather)

(load custom-file 'noerror)

