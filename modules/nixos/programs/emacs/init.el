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

(use-package elementary-emacs-nix :ensure nil :demand t)

(use-package elementary-emacs-python :ensure nil :demand t)

(use-package elementary-emacs-java :ensure nil :demand t)

(use-package elementary-emacs-rust :ensure nil :demand t)

(use-package elementary-emacs-markdown :ensure nil :demand t)

(use-package elementary-emacs-web :ensure nil :demand t)

(use-package elementary-emacs-csharp :ensure nil :demand t)

(use-package elementary-emacs-agents :ensure nil :demand t)

(add-to-list 'auto-mode-alist '("\\(Containerfile\\|Dockerfile\\).*" . dockerfile-ts-mode))

(use-package docker
  :general
  (gg/leader
    "k" #'docker))

(use-package yaml-mode
  :hook (yaml-mode . lsp))

(use-package terraform-mode
  :hook (terraform-mode . lsp-deferred))

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

(use-package powershell
  :defer t)

(use-package age
  :hook (after-init . (lambda ()
                        (let ((inhibit-message t))
                          (age-file-enable))))
  :custom
  (age-default-identity "~/.ssh/id_ed25519")
  (age-default-recipient "~/.ssh/id_ed25519.pub"))

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
