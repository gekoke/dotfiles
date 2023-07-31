(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq gc-cons-threshold 1100000000) ; ~1.02 GiB
(setq read-process-output-max (* 1024 1024))

(setq use-package-always-ensure t)

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

(setq create-lockfiles nil)
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "emacs-backups"))))
(setq auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "emacs-autosaves") t)))
(use-package undo-tree :custom
  (undo-tree-history-directory-alist `(("." . ,(concat user-emacs-directory "undo-tree-history")))))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-message t)
(setq native-comp-async-report-warnings-errors nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(save-place-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(global-auto-revert-mode 1)
(set-fringe-mode 8)
(column-number-mode)

(setq display-line-numbers-type 'relative)
(dolist (hook '(prog-mode-hook
                conf-mode-hook
                js-json-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 1))))

(setq-default indent-tabs-mode nil)
(electric-pair-mode t)
(show-paren-mode 1)

(add-hook 'prog-mode-hook 'hs-minor-mode)

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

(use-package doom-modeline
  :after nerd-icons
  :init
  (doom-modeline-mode 1)
  :custom
  ((doom-modeline-height 30)
   (doom-modeline-indent-info t)
   (doom-modeline-modal-icon nil)
   (doom-modeline-display-default-persp-name t)
   (doom-modeline-buffer-file-name-style 'truncate-nil)))

(setq custom-safe-themes t)
(use-package doom-themes)
(use-package catppuccin-theme :custom (catppuccin-flavor 'macchiato))
(use-package darcula-theme)
(use-package color-theme-sanityinc-tomorrow)

(use-package remember-last-theme
  :config
  (remember-last-theme-enable))

(set-frame-font "JetBrainsMono Nerd Font 13" nil t)

(use-package ligature
  :load-path "path-to-ligature-repo"
  :config
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ">>=" ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))
  (global-ligature-mode nil))

(use-package beacon
  :custom
  (beacon-mode 1))

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

(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t))

(use-package emacs
  :after vertico
  ;; Hide commands in M-x which do not work in the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  (recursive-minibuffers t))

(use-package all-the-icons)
;; This MUST come before the `marginalia' definition.
(use-package all-the-icons-completion
  :after all-the-icons
  :init
  (add-hook 'marginalia-mode-hook #'all-the-icons-completion-marginalia-setup))

(use-package marginalia
  :init
  ;; Marginalia must be actived in the :init section
  (marginalia-mode)
  :general
  (general-def minibuffer-local-map "M-A" #'marginalia-cycle))

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

(use-package helpful
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

(use-package evil
  :demand t
  :custom
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  :general
  (gg/leader
    "s" #'save-buffer))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-magit-use-z-for-folds t)
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

(use-package evil-vimish-fold)

(use-package evil-matchit
  :init
  (global-evil-matchit-mode 1))

(use-package pdf-tools
  :init
  (pdf-tools-install))

(use-package dirvish
  :after all-the-icons
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("t" "~/.local/share/Trash/files/" "Trash")
     ("p" "~/Pictures"                  "Pictures")))

  (dirvish-emerge-groups
   '(("Recent files" (predicate . recent-files-2h))
     ("Documents" (extensions "pdf" "tex" "bib" "epub"))
     ("Video" (extensions "mp4" "mkv" "webm"))
     ("Pictures" (extensions "jpg" "png" "svg" "gif" "webp"))
     ("Audio" (extensions "mp3" "flac" "wav" "ape" "aac"))
     ("Archives" (extensions "gz" "rar" "zip"))))

  (dirvish-mode-line-format '(:left (sort symlink omit) :right (vc-info yank index)))
  (dirvish-header-line-format '(:left (path) :right (free-space)))
  (dirvish-path-separators (list "  " "  " "  "))

  (delete-by-moving-to-trash t)

  (dirvish-media-auto-cache-threshold '(500 . 8))

  (dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")

  (dired-mouse-drag-files t)
  (mouse-drag-and-drop-region-cross-program t)

  (dirvish-attributes
        '(all-the-icons file-time file-size subtree-state vc-state git-msg))
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
    "TAB"  #'dirvish-subtree-toggle
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

(use-package corfu
  :custom
  (completion-ignore-case t)
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-delay 0)
  (corfu-auto-prefix 0)

  (corfu-min-width 40)
  (corfu-max-width 160)

  (corfu-popupinfo-mode t)
  (corfu-popupinfo-delay '(0.1 . 0.1))
  (corfu-popupinfo-min-width 50)
  (corfu-popupinfo-max-width 160)
  (corfu-popupinfo-max-height 15)
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

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; To compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package vterm)
(use-package vterm-toggle
  :general
  (gg/leader
    "o" #'vterm-toggle))

(use-package magit
  :custom
  (magit-no-confirm '(set-and-push stage-all-changes unstage-all-changes))
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  :general
  (gg/leader
    "v" #'magit-status))

(use-package magit-todos
  :after magit
  :init
  (magit-todos-mode))

(use-package diff-hl
  :custom
  (diff-hl-show-staged-changes nil)
  (diff-hl-ask-before-revert-hunk nil)
  :init
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)
  :general
  (gg/leader
    "g" '(:ignore t :which-key "VC")
    "g s" #'diff-hl-stage-current-hunk
    "g r" #'diff-hl-revert-hunk))

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
    "p" '(:keymap projectile-command-map :which-key "Project"))
  (general-def projectile-command-map
    "a" #'projectile-add-known-project
    "A" #'projectile-find-other-file))

(use-package consult-projectile
  :general
  (gg/leader
    "SPC" #'consult-projectile-find-file
    "b" #'consult-projectile-switch-to-buffer
    "B" #'consult-buffer)
  (general-def projectile-command-map
    "p" #'consult-projectile-switch-project))

(use-package persp-mode
  :custom
  (persp-nil-name "main")
  (persp-auto-resume-time 0.001)
  :general
  (gg/leader
    "TAB" '(:keymap persp-key-map :which-key "Perspective"))
  :config
  (persp-mode 1))

(use-package direnv
 :config
 (direnv-mode))

(use-package cape
  :init
  (defun gg/setup-elisp-mode-capf ()
    (setq-local completion-at-point-functions (list
                              (cape-capf-nonexclusive #'elisp-completion-at-point)
                              #'cape-file
                              #'cape-dabbrev
                              #'cape-keyword)))
  :hook
  (emacs-lisp-mode . gg/setup-elisp-mode-capf)
  :custom
  (cape-dabbrev-check-other-buffers nil))

(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package yasnippet
  :init
  (yas-global-mode 1))

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
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  (lsp-completion-mode . gg/setup-lsp-mode-capf)
  :custom
  (lsp-completion-provider :none) ;; We use Corfu!
  (lsp-headerline-breadcrumb-enable nil)
  :general
  (gg/leader lsp-mode-map
    "l" '(:keymap lsp-command-map))
  (general-def lsp-command-map
    "= r" #'lsp-format-region)
  :commands lsp)

(use-package lsp-ui
  :after lsp-mode
  :hook (prog-mode . lsp-ui-mode)
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-position 'at-point)
  :general
  (general-def
    :states 'normal
    "g h" #'lsp-ui-doc-glance))

(use-package lsp-nix
  :ensure lsp-mode
  :after lsp-mode
  :demand t
  :custom
  (lsp-nix-nil-formatter ["nixpkgs-fmt"]))

(use-package nix-mode
  :hook (nix-mode . lsp-deferred))

(use-package haskell-mode)

(use-package lsp-haskell
  :defer t
  :hook
  (haskell-mode . lsp-deferred)
  :custom
  (lsp-haskell-server-path (executable-find "haskell-language-server-wrapper")))

(use-package web-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

(use-package lsp-html
  :ensure nil
  :defer t
  :hook
  (html-mode . lsp-deferred))

(use-package css-mode :ensure nil)

(use-package lsp-css
  :ensure nil
  :defer t
  :hook
  (css-mode . lsp-deferred))

(use-package emmet-mode
  :hook
  (html-mode-hook . emmet-mode)
  (css-mode-hook. emmet-mode)
  :init
  (defun gg/indent-or-yas-or-emmet-expand ()
    "Do-what-I-mean on TAB.

Invokes `indent-for-tab-command' if at or before text bol, `yas-expand' if on a
snippet, or `emmet-expand-yas'/`emmet-expand-line', depending on whether
`yas-minor-mode' is enabled or not."
    (interactive)
    (call-interactively
     (cond ((or (<= (current-column) (current-indentation))
                (not (eolp))
                (not (or (memq (char-after) (list ?\n ?\s ?\t))
                         (eobp))))
            #'indent-for-tab-command)
           ((require 'yasnippet)
            (if (yas--templates-for-key-at-point)
                #'yas-expand
              #'emmet-expand-yas))
           (#'emmet-expand-line))))
  :general
  (general-def
    :keymap 'emmet-mode-map
    :states 'visual
    "TAB" #'emmet-wrap-with-markup)
  (general-def 
    :keymap 'emmet-mode-map
    "TAB" #'gg/indent-or-yas-or-emmet-expand))

(use-package age
  :demand t
  :custom
  (age-program "rage")
  (age-default-identity "~/.ssh/id_ed25519")
  (age-default-recipient "~/.ssh/id_ed25519.pub")
  :config
  (age-file-enable))

(general-def
  "<escape>" #'keyboard-escape-quit
  "C--" #'text-scale-decrease
  "C-=" #'text-scale-increase)

(general-def
  :states 'insert
  "C-." #'completion-at-point)

(gg/leader
  "." #'find-file
  "x" #'kill-current-buffer
  "z" #'bury-buffer)

(load custom-file 'noerror)
