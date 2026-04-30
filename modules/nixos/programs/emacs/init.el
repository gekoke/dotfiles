(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq gc-cons-threshold 1000000000)
(setq read-process-output-max (* 1024 1024))

(setq-default tab-width 4)

(use-package general
  :demand t
  :config
  (general-create-definer gg/leader
    :states '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (general-create-definer gg/local
    :states '(normal insert visual emacs)
    :prefix "SPC m"
    :global-prefix "C-SPC m"))

(use-package editorconfig
  :ensure t
  :hook (after-init . editorconfig-mode))

(use-package time
  :hook (after-init . display-time-mode)
  :custom
  (display-time-24hr-format t)
  (display-time-default-load-average nil))

(use-package calendar
  :defer t
  :custom
  (calendar-week-start-day 1))

(use-package emacs
  :init
  (setq kill-buffer-query-functions nil)
  :general
  (gg/leader
    "i" #'ibuffer
    "B r" #'rename-buffer))

(use-package undo-tree
  :hook (after-init . global-undo-tree-mode)
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
  :hook (after-init . eyebrowse-mode)
  :custom
  (eyebrowse-new-workspace #'dashboard-open)
  (eyebrowse-mode-line-left-delimiter "🔨 ")
  (eyebrowse-mode-line-separator " | ")
  (eyebrowse-mode-line-right-delimiter " ")
  (eyebrowse-tagged-slot-format "%s • %t")
  :config
  (with-eval-after-load 'magit
    (general-def
      :states 'normal
      :keymaps 'magit-section-mode-map
      "C-<tab>" #'eyebrowse-last-window-config))
  :general
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

(use-package text-mode
  :defer t
  :custom
  ;; Disable annoying message "can't find dictionary in system default locations"
  (text-mode-ispell-word-completion nil))

(use-package jinx
  :hook (text-mode . jinx-mode))

(defun gg/set-background-opacity (opacity)
  "Interactively change the current frame's OPACITY."
  (interactive
   (list (read-number "Opacity (0-100): "
                      (or (frame-parameter nil 'alpha)
                          100))))
  (set-frame-parameter nil 'alpha-background opacity))

(gg/leader
  "t o" #'gg/set-background-opacity)

(use-package nerd-icons
  :demand t
  :config
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
    (setf nerd-icons-regexp-icon-alist (assoc-delete-all regexp nerd-icons-regexp-icon-alist))))

(use-package package-lint
  :defer t)

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 32)
  (doom-modeline-indent-info t)
  (doom-modeline-modal nil)
  (doom-modeline-check-icon nil)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-workspace-name nil)
  (doom-modeline-buffer-file-name-style 'relative-from-project))

(use-package nyan-mode
  :hook (doom-modeline-mode . nyan-mode)
  :custom
  (nyan-animation-frame-interval (/ 1.0 20)))

(use-package dashboard
  :demand t
  :after (consult nerd-icons)
  :init
  (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
  :custom
  (dashboard-startup-banner '3)
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
(use-package doom-themes :defer t)
(use-package ef-themes :defer t)
(use-package gruvbox-theme :defer t)
(use-package modus-themes :defer t)
(use-package catppuccin-theme
  :defer t
  :custom
  (catppuccin-flavor 'frappe))
(use-package miasma-theme :defer t)

(use-package remember-last-theme
  :demand t
  :config
  (remember-last-theme-enable))

(set-frame-font "-IBM -BlexMono Nerd Font-bold-normal-normal-*-*-*-*-*-m-0-iso10646-1" nil t)

(use-package ligature
  :hook (after-init . global-ligature-mode)
  :config
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ">>=" ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++")))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package olivetti
  :commands (olivetti-mode prog-olivetti-mode global-prog-olivetti-mode)
  :init
;;;###autoload
  (define-minor-mode prog-olivetti-mode
    "Minor mode to enable `olivetti-mode` in `prog-mode` derived buffers."
    (add-hook 'prog-mode-hook #'olivetti-mode))

;;;###autoload
  (define-globalized-minor-mode global-prog-olivetti-mode
    prog-olivetti-mode
    (lambda ()
      (when (derived-mode-p 'prog-mode)
        (olivetti-mode 1))))
  :custom
  (olivetti-body-width 220)
  :general
  (gg/leader
    "t c" 'olivetti-mode
    "t C" 'global-prog-olivetti-mode))

(use-package which-key
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 0.4))

(use-package rg :defer t)
(use-package wgrep :defer t)

(use-package embark
  :general
  (general-def
    "M-e" #'embark-export))

(use-package vertico
  :hook (after-init . vertico-mode)
  :custom
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  (vertico-cycle t)
  :general
  (general-def minibuffer-local-map
    "M-j" #'next-line-or-history-element
    "M-k" #'previous-line-or-history-element))

(use-package marginalia
  :hook (after-init . marginalia-mode)
  :general
  (general-def minibuffer-local-map "M-A" #'marginalia-cycle))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package orderless
  :defer t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package project
  :defer t
  :custom
  (project-switch-commands
   '((project-find-file "File" "f")
     (project-find-dir "Directory" "d")
     (consult-ripgrep "Search" "/")))
  :general
  (gg/leader
    "SPC" #'project-find-file
    "p p" #'project-switch-project))

(use-package consult
  :demand t
  :after remember-last-theme
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq project-read-file-name-function #'consult-project-find-file-with-preview)

  (defun consult-project-find-file-with-preview (prompt all-files &optional pred hist _mb)
    (let ((prompt (if (and all-files
                           (file-name-absolute-p (car all-files)))
                      prompt
                    ( concat prompt
                      ( format " in %s"
                        (consult--fast-abbreviate-file-name default-directory)))))
          (minibuffer-completing-file-name t))
      (consult--read (mapcar
                      (lambda (file)
                        (file-relative-name file))
                      all-files)
                     :state (consult--file-preview)
                     :prompt (concat prompt ": ")
                     :require-match t
                     :history hist
                     :category 'file
                     :predicate pred)))
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
  (defun gg/consult-buffer-vterm ()
    (interactive)
    (minibuffer-with-setup-hook
        (lambda () (insert "vterm"))
      (consult-buffer)))
  :general
  (gg/leader
    "b" #'consult-buffer
    "o v" #'gg/consult-buffer-vterm
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

(winner-mode +1)

(repeat-mode +1)

(general-def
  "C-s" #'avy-goto-char-2)

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

(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

(use-package dirvish
  :hook (after-init . dirvish-override-dired-mode)
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
  (dirvish-path-separators (list "  🏠" "  🔒" " ➤ "))

  (delete-by-moving-to-trash t)

  (dirvish-show-media-properties t)
  (dirvish-media-auto-cache-threshold '(500 . 8))

  (dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")

  (dired-mouse-drag-files t)
  (mouse-drag-and-drop-region-cross-program t)

  (dirvish-attributes
   '(nerd-icons file-size file-time subtree-state vc-state git-msg))

  (dirvish-side-attributes
   '(nerd-icons subtree-state vc-state git-msg))
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
    "e" #'wdired-change-to-wdired-mode
    "d" #'dirvish-fd
    "g" #'dirvish-emerge-mode
    "f" #'dired-create-empty-file
    "k" #'dired-create-directory))

(use-package dirvish-side
  :hook (after-init . dirvish-side-follow-mode))

(use-package dired-gitignore
  :general
  (gg/local
    :keymaps 'dirvish-mode-map
    "i" #'dired-gitignore-global-mode))

(use-package diredfl
  :hook
  (dired-mode . diredfl-mode)
  (dirvish-directory-view-mode . diredfl-mode)
  :config
  (set-face-attribute 'diredfl-dir-name nil :bold t))

(use-package dired
  :defer t
  :custom
  (dired-deletion-confirmer (lambda (_) t)))

(use-package dired-x
  :after dired
  :config
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..*$")))

(use-package cape
  :init
  (setq-default completion-at-point-functions (list
                                               #'cape-file
                                               #'cape-dabbrev
                                               #'cape-keyword))
  (defun gg/setup-elisp-mode-capf ()
    (require 'cape)
    (setq-local completion-at-point-functions (list
                                               (cape-capf-nonexclusive #'elisp-completion-at-point)
                                               #'cape-file
                                               #'cape-dabbrev
                                               #'cape-keyword)))
  :hook
  (emacs-lisp-mode . gg/setup-elisp-mode-capf))

(use-package corfu
  :hook (after-init . global-corfu-mode)
  :custom
  (completion-ignore-case t)
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-delay (/ 1.0 60))
  (corfu-auto-prefix 1)
  (corfu-popupinfo-mode t)
  (corfu-min-width 40)
  (corfu-popupinfo-delay '(0 . 0)))

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
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

;; NOTE: login with `gptel-gh-login'
(use-package gptel
  :ensure t
  :defer t
  :custom
  (gptel-prompt-prefix-alist '((markdown-mode . "> ")))
  :config
  ;; FIXME: `:custom' doesn't work
  ;; See: https://github.com/karthink/gptel/issues/556
  (setq gptel-model 'gpt-5
        gptel-backend (gptel-make-gh-copilot "Copilot"))
  :general
  (gg/leader
    "c b" #'gptel
    "c m" #'gptel-menu))

(use-package vterm
  :defer t
  :custom
  (vterm-max-scrollback 10000))

(use-package vterm-toggle
  :commands (vterm-toggle-cd vterm-toggle-forward vterm-toggle-backward
             vterm-toggle--new gg/vterm-new gg/cmatrix)
  :custom
  (vterm-toggle-reset-window-configration-after-exit nil)
  :init
  (defun gg/vterm-new ()
    (interactive)
    (vterm-toggle--new))
  (defun gg/cmatrix ()
    "Set up terminal emulators in a nice layout."
    (interactive)
    (delete-other-windows)
    (vterm-toggle--new)
    (delete-other-windows)
    (evil-window-split)
    (evil-window-down 1)
    (vterm-toggle--new)
    (evil-window-vsplit)
    (evil-window-right 1)
    (vterm-toggle--new)
    (evil-window-up 1))
  :general
  (gg/leader
    "o o" #'vterm-toggle-cd
    "o n" #'gg/vterm-new
    "o j" #'vterm-toggle-forward
    "o k" #'vterm-toggle-backward))

;; Don't make new frame for ediff - why would I want that?!
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package magit
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
    ;; Empty (annotated) tag messages must be permitted because it is
    ;; impossible to create them interactively.
    :allow-empty t)
  (transient-append-suffix
    'magit-tag
    "-u"
    '(magit-tag:--message)))

(use-package forge
  :after magit
  :custom
  (forge-add-default-bindings nil) ;; Use evil-collection instead
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
  :hook (after-init . global-hl-todo-mode))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package flycheck
  :hook (after-init . global-flycheck-mode)
  :custom
  (flycheck-indication-mode 'right-fringe))

(use-package treesit-auto
  :hook (after-init . global-treesit-auto-mode)
  :config
  (delete 'rust treesit-auto-langs) ;; conflicts with mode set up by rustic-mode config
  (delete 'c-sharp treesit-auto-langs)) ;; sucks

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
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  (lsp-mode . yas-minor-mode)
  (lsp-completion-mode . gg/setup-lsp-mode-capf)
  :custom
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-inlay-hint-enable t)
  (lsp-semantic-tokens-enable t)
  (lsp-semantic-tokens-honor-refresh-requests t)
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

(use-package lsp-nix
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
  :after lsp-mode)

(use-package python
  :defer t
  :init
  (add-hook 'before-save-hook (lambda ()
                                (when (and
                                       (eq major-mode 'python-ts-mode)
                                       (bound-and-true-p lsp-mode))
                                  (lsp-format-buffer)))))

(use-package lsp-java
  :hook (java-ts-mode . (lambda ()
                          (load "lsp-java.el")
                          (lsp))))

(use-package rustic
  :mode
  ("\\.rs\\'" . rustic-mode)
  :custom
  (rustic-format-trigger t))

(use-package lsp-rust
  :after lsp-mode
  :custom
  (lsp-rust-analyzer-lens-references-adt-enable t)
  (lsp-rust-analyzer-lens-references-trait-enable t)
  (lsp-rust-analyzer-lens-references-enum-variant-enable t)
  (lsp-rust-analyzer-max-inlay-hint-length 15)
  (lsp-rust-analyzer-diagnostics-enable-experimental t)
  (lsp-rust-clippy-preference "on"))

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)
  :custom
  (markdown-fontify-code-blocks-natively t)
  :config
  (add-to-list 'markdown-code-lang-modes '("py" . python-mode))
  (add-to-list 'markdown-code-lang-modes '("python" . python-mode)))

(use-package web-mode
  :mode
  ("\\.phtml\\'" . web-mode)
  ("\\.tpl\\.php\\'" . web-mode)
  ("\\.[agj]sp\\'" . web-mode)
  ("\\.as[cp]x\\'" . web-mode)
  ("\\.erb\\'" . web-mode)
  ("\\.mustache\\'" . web-mode)
  ("\\.djhtml\\'" . web-mode)
  :hook
  (web-mode . lsp)
  (web-mode . (lambda ()
                (progn
                  (require 'sgml-mode)
                  (sgml-electric-tag-pair-mode))))
  (web-mode . (lambda () (electric-pair-local-mode -1)))
  :custom
  (web-mode-script-padding 4)
  (web-mode-enable-auto-pairing t)
  (web-mode-enable-auto-opening t)
  (web-mode-enable-auto-quoting t))

(use-package html-ts-mode
  :mode
  ("\\.html\\'" . html-ts-mode)
  :hook
  (html-ts-mode . lsp-deferred))

(use-package lsp-tailwindcss
  :after lsp-mode
  :init
  (setq lsp-tailwindcss-add-on-mode t))

(use-package typescript-ts-mode
  :mode
  ("\\.ts\\'" . typescript-ts-mode)
  ("\\.tsx\\'" . tsx-ts-mode)
  :hook
  (typescript-ts-mode . lsp)
  (tsx-ts-mode . lsp)
  :config
  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp--formatting-indent-alist '(tsx-ts-mode . typescript-ts-mode-indent-offset))))

(use-package lsp-javascript
  :after lsp-mode
  :custom
  (lsp-typescript-references-code-lens-enabled t)
  (lsp-typescript-implementations-code-lens-enabled t))

(use-package js
  :hook
  (js-ts-mode . lsp)
  :mode
  ("\\.mjs\\'" . js-ts-mode)
  ("\\.js\\'" . js-ts-mode)
  :custom
  (js-indent-level 2))

(add-hook 'csharp-mode-hook #'lsp)
(add-hook 'csharp-ts-mode-hook #'lsp)

(add-to-list 'auto-mode-alist '("\\(Containerfile\\|Dockerfile\\).*" . dockerfile-ts-mode))

(use-package docker
  :general
  (gg/leader
    "k" #'docker))

(use-package yaml-mode
  :hook (yaml-mode . lsp))

(use-package terraform-mode
  :hook (terraform-mode . lsp-deferred))

(use-package feature-mode
  :defer t)

(use-package go-ts-mode
  :hook (go-ts-mode . lsp)
  :custom
  (go-ts-mode-indent-offset tab-width))

(use-package typst-ts-mode
  :custom
  (typst-ts-mode-indent-offset 2)
  :config
  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection "tinymist")
      :activation-fn (lsp-activate-on "typst")
      :server-id 'typst-lsp))))

(use-package json-ts-mode
  :hook
  (json-ts-mode . lsp))

(use-package powershell
  :defer t)

(use-package age
  :hook (after-init . (lambda ()
                        (let ((inhibit-message t))
                          (age-file-enable))))
  :custom
  (age-default-identity "~/.ssh/id_ed25519")
  (age-default-recipient "~/.ssh/id_ed25519.pub"))

(use-package hackernews
  :defer t)

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
  "x" #'kill-buffer-and-window
  "X" #'kill-current-buffer
  "z" #'bury-buffer
  "E e" #'eval-buffer
  "E r" #'eval-region
  "r" '(:ignore t :which-key "Regex")
  "r l" #'align-regexp)

(defun gg/hex-to-decimal (hex)
  "Convert the base-16 integer represented by string HEX to decimal."
  (interactive "MHex: ")
  (shell-command (format "echo $((16#%s))" hex)))

(defun gg/weather ()
  "Show the weather."
  (interactive)
  (async-shell-command "curl 'wttr.in?M'"))

(gg/leader
  "u w" #'gg/weather)

(defun gg/jwt-decode (jwt)
  (async-shell-command (format "jwt decode %s --json | jq" jwt)))

(defun gg/jwt-decode-clipboard ()
    (interactive)
    (let
        ((jwt (current-kill 0)))
      (gg/jwt-decode jwt)))

(gg/leader
  "j d" #'gg/jwt-decode-clipboard)

(load custom-file)
