(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(use-package treesit
  :custom
  (treesit-font-lock-level 4))

(use-package elementary-emacs-keys :ensure nil :demand t)
(use-package elementary-emacs-prelude :ensure nil :demand t)
(use-package elementary-emacs-editor :ensure nil :demand t)

(setq-default left-fringe-width 4)
(setq-default right-fringe-width 12)

(use-package package-lint
  :defer t)

(use-package elementary-emacs-themes :ensure nil :demand t)
(use-package elementary-emacs-visual :ensure nil :demand t)
(use-package elementary-emacs-completion :ensure nil :demand t)
(use-package elementary-emacs-workspaces :ensure nil :demand t)

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


  (dirvish-default-layout '(1 0.11 0.4))

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
             vterm-toggle--new gg/vterm-new)
  :custom
  (vterm-toggle-reset-window-configration-after-exit nil)
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

(use-package lsp-java
  :hook (java-ts-mode . (lambda ()
                          (load "lsp-java.el")
                          (lsp-deferred))))

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
  (web-mode . lsp-deferred)
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

(use-package csharp-ts-mode
  :mode ("\\.cs\\'" . csharp-ts-mode)
  :hook (csharp-ts-mode . lsp-deferred))

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
