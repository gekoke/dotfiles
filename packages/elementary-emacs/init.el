;; -*- lexical-binding: t; -*-
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(use-package treesit
  :custom
  (treesit-font-lock-level 4))

(use-package elementary-emacs-keys :ensure nil :demand t)
(use-package elementary-emacs-prelude :ensure nil :demand t)
(use-package elementary-emacs-editor :ensure nil :demand t)

(setq-default left-fringe-width 4)
(setq-default right-fringe-width 4)

(use-package elementary-emacs-themes :ensure nil :demand t)
(use-package elementary-emacs-visual :ensure nil :demand t)
(use-package elementary-emacs-completion :ensure nil :demand t)
(use-package elementary-emacs-workspaces :ensure nil :demand t)

(use-package elementary-emacs-files :ensure nil :demand t)

(use-package elementary-emacs-terminal :ensure nil :demand t)

(use-package elementary-emacs-vc :ensure nil :demand t)

(use-package elementary-emacs-lsp :ensure nil :demand t)

(use-package elementary-emacs-nix :ensure nil :demand t)

(use-package elementary-emacs-python :ensure nil :demand t)


(use-package elementary-emacs-rust :ensure nil :demand t)

(use-package elementary-emacs-markdown :ensure nil :demand t)

(use-package elementary-emacs-web :ensure nil :demand t)

(use-package elementary-emacs-csharp :ensure nil :demand t)

(use-package elementary-emacs-agents :ensure nil :demand t)

(use-package elementary-emacs-docker :ensure nil :demand t)

(use-package elementary-emacs-terraform :ensure nil :demand t)

(use-package elementary-emacs-yaml :ensure nil :demand t)

(use-package elementary-emacs-go :ensure nil :demand t)

(use-package elementary-emacs-powershell :ensure nil :demand t)

(use-package elementary-emacs-typst :ensure nil :demand t)

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
