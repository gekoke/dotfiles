(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Server paths injected at build time by the `elementary-emacs' package.
(setq lsp-csharp-server-path "@omnisharp@/bin/OmniSharp")
(setq lsp-pwsh-dir "@pwshDir@")
(setq lsp-tailwindcss-server-path "@tailwindcssLs@")
(setq lsp-clients-typescript-tls-path "@typescriptLs@")

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

(use-package elementary-emacs-files :ensure nil :demand t)

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

(use-package elementary-emacs-terminal :ensure nil :demand t)

(use-package elementary-emacs-vc :ensure nil :demand t)

(use-package elementary-emacs-lsp :ensure nil :demand t)

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

(load custom-file t)
