(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(setq use-package-always-ensure t)
(setq use-package-always-demand t)

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


(add-to-list 'display-buffer-alist
            '("\\*compilation*"
              nil
              (reusable-frames . t)))

(use-package indent-bars
  :ensure nil
  :config
  (require 'indent-bars-ts)
  :custom
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  (indent-bars-treesit-support t))

(use-package emacs
  :ensure nil
  :custom
  (whitespace-style '(face
                      trailing
                      tabs
                      empty
                      newline
                      newline-mark
                      indentation
                      spaces
                      space-mark
                      space-after-tab
                      space-before-tab
                      tab-mark)))

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
  (doom-modeline-height 20)
  (doom-modeline-indent-info t)
  (doom-modeline-modal-icon nil)
  (doom-modeline-check-icon nil)
  (doom-modeline-buffer-state-icon nil)
  (doom-modeline-buffer-file-name-style 'file-name-with-project))
 
(use-package eyebrowse
  :init
  (eyebrowse-mode 1)
  :custom
  (eyebrowse-new-workspace #'dashboard-open)
  :general
  (general-def
    "C-<tab>" 'eyebrowse-last-window-config)
  (gg/leader
    "<tab> k" #'eyebrowse-prev-window-config
    "<tab> j" #'eyebrowse-next-window-config
    "<tab> <tab>" #'eyebrowse-last-window-config
    "<tab> d" #'eyebrowse-close-window-config
    "<tab> 0" #'eyebrowse-switch-to-window-config-0
    "<tab> 1" #'eyebrowse-switch-to-window-config-1
    "<tab> 2" #'eyebrowse-switch-to-window-config-2
    "<tab> 3" #'eyebrowse-switch-to-window-config-3
    "<tab> 4" #'eyebrowse-switch-to-window-config-4
    "<tab> 5" #'eyebrowse-switch-to-window-config-5
    "<tab> 6" #'eyebrowse-switch-to-window-config-6
    "<tab> 7" #'eyebrowse-switch-to-window-config-7
    "<tab> 8" #'eyebrowse-switch-to-window-config-8
    "<tab> 9" #'eyebrowse-switch-to-window-config-9))

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


(use-package remember-last-theme
  :config
  (remember-last-theme-enable))

(set-face-attribute 'default nil :family "Iosevka Term Nerd Font" :height 105 :weight 'normal)

(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ">>=" ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++")))

(use-package olivetti
  :init
  (add-hook 'woman-mode-hook 'olivetti-mode)
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
  (forge-add-default-bindings nil)
  (magit-diff-refine-hunk 'all)
  (magit-status-margin '(t age magit-log-margin-width t 18))
  :config
  (evil-collection-init))

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
     ("x" "~/Documents/"                           "Documents")
     ("d" "~/Downloads/"                           "Downloads")
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
    "N"    #'dirvish-narrow
    "^"    #'dirvish-history-last
    "$"    #'dirvish-history-jump
    "s"    #'dirvish-quicksort  ; remapped `dired-sort-toggle-or-edit'
    "v"    #'dirvish-vc-menu    ; remapped `dired-view-file'
    "."    #'dired-omit-mode    ; remapped `dired-clean-directory'
    "RET"  #'dirvish-subtree-toggle
    "M-l"  #'dirvish-ls-switches-menu
    "M-m"  #'dirvish-mark-menu
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
  :hook (dired-mode . dired-omit-mode))

(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0)
  (company-tooltip-align-annotations t)
  (company-abort-on-unique-match nil)
  (company-frontends '(company-pseudo-tooltip-frontend
                        company-echo-metadata-frontend))
  (company-backends
   '(company-bbdb
     company-semantic
     company-cmake
     (company-files company-capf)
     company-clang
     (company-dabbrev-code company-gtags company-etags company-keywords)
     company-oddmuse
     company-dabbrev))
  :general
  (general-def
    :keymaps 'company-active-map
    "RET" nil
    "<tab>" #'company-complete-selection
    "C-." #'company-complete)
  (general-def
    :keymaps 'company-mode-map
    "C-." #'company-complete))

(use-package company-quickhelp
  :init
  (company-quickhelp-mode))

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

(use-package magit
  :hook (magit-log-mode . magit-diff-show-or-scroll-up)
  :init
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (defun magit-auto-fetch ()
    (interactive)
    (magit-fetch-all ())
    (forge-pull))
  (advice-add 'magit-status :after #'magit-auto-fetch)

  (defun magit-log-custom-propertize-keywords (_rev msg)
    (let ((boundary 0))
      (when (string-match "^\\(?:squash\\|fixup\\)! " msg boundary)
        (setq boundary (match-end 0))
        (magit--put-face (match-beginning 0) (1- boundary)
                         'magit-keyword-squash msg))
      (when magit-log-highlight-keywords
        ;; Case [...]
        (while (string-match "\\[[^[]*?]" msg boundary)
          (setq boundary (match-end 0))
          (magit--put-face (match-beginning 0) boundary
                           'magit-keyword msg))
        ;; Revert commits
        (while (string-match "^Revert" msg boundary)
          (setq boundary (match-end 0))
          (magit--put-face (match-beginning 0) boundary
                           'error msg))
        msg)))

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

(use-package magit-file-icons
  :ensure nil
  :config
  (magit-file-icons-mode))

(use-package forge
  :after magit
  :custom
  (forge-owned-accounts '(("gekoke"))))

(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

(use-package blamer
  :custom
  (blamer-idle-time 0.25)
  (blamer-min-offset 60)
  (blamer-max-commit-message-length 120)
  :custom-face
  (blamer-face ((t :background nil
                   :weight normal
                   :italic nil)))
  :config
  (global-blamer-mode 1))

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
    "b" #'consult-projectile-switch-to-buffer
    "B" #'consult-buffer)
  (general-def projectile-command-map
    "p" #'consult-projectile-switch-project))

(use-package envrc
  :config
  (envrc-global-mode))

(use-package flycheck
  :init
  (global-flycheck-mode)
  :custom
  (flycheck-indication-mode 'right-fringe)
  (flycheck-display-errors-delay 0))

(use-package treesit-auto
  :config
  (delete 'yaml treesit-auto-langs) ;; yaml-mode is superior
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
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  (lsp-mode . yas-minor-mode)
  :custom
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-completion-provider :none)
  (lsp-eldoc-render-all t)
  (lsp-inlay-hint-enable t)
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
                            (lsp))))

(use-package lsp-ruff-lsp
  :ensure lsp-mode
  :after lsp-mode)

(use-package python
  :ensure nil
  :init
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
  :hook
  (rust-ts-mode . lsp-deferred)
  :init
  (add-hook 'before-save-hook (lambda ()
                                (when (and
                                       (eq major-mode 'rustic-mode)
                                       (bound-and-true-p lsp-mode))
                                  (lsp-format-buffer))))
  :custom
  (rust-mode-treesitter-derive t))

(use-package lsp-rust
  :custom
  (lsp-rust-analyzer-lens-references-adt-enable t)
  (lsp-rust-analyzer-lens-references-trait-enable t)
  (lsp-rust-analyzer-lens-references-enum-variant-enable t)
  (lsp-rust-analyzer-max-inlay-hint-length 15)
  (lsp-rust-clippy-preference "on"))

(use-package markdown-mode
  :custom
  (markdown-fontify-code-blocks-natively t)
  :config
  (add-to-list 'markdown-code-lang-modes '("py" . python-mode))
  (add-to-list 'markdown-code-lang-modes '("python" . python-mode)))

(use-package web-mode
  :hook (web-mode . lsp)
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

(use-package terraform-mode
  :custom
  (add-hook 'terraform-mode-hook 'my-terraform-mode-init))

(use-package feature-mode)

(use-package age
  :custom
  (age-program "rage")
  (age-default-identity "~/.ssh/id_ed25519")
  (age-default-recipient "~/.ssh/id_ed25519.pub")
  :config
  (age-file-enable))

(general-def
  "C--" #'text-scale-decrease
  "C-=" #'text-scale-increase)

(gg/leader
  :keymaps 'smerge-mode-map
  "m" '(:ignore t :which-key "Merge")
  "m u" #'smerge-keep-upper
  "m l" #'smerge-keep-lower
  "m t" #'smerge-keep-current
  "m b" #'smerge-keep-all)

(gg/leader
  "." #'find-file
  "x" #'kill-current-buffer
  "z" #'bury-buffer
  "E" #'eval-buffer
  "e" #'eval-region
  "r" '(:ignore t :which-key "Regex")
  "r l" #'align-regexp)

(load custom-file)
