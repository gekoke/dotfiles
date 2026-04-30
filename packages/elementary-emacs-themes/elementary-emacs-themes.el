;;; elementary-emacs-themes.el --- Theme set and persistence -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (catppuccin-theme "2.0") (consult "1.0") (doom-themes "2.3") (ef-themes "1.0") (general "0.1") (gruvbox-theme "1.30") (modus-themes "4.0") (remember-last-theme "0.1") (miasma-theme "0.1") (elementary-emacs-keys "0.1"))
;; Keywords: faces

;;; Commentary:

;; Bundles the curated set of themes used by Elementary Emacs together
;; with `remember-last-theme' for persistence across sessions and a
;; thin `consult-theme' wrapper that records the selection.

;;; Code:

(require 'elementary-emacs-keys)

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

(use-package consult
  :defer t
  :config
  (defun gg/consult-theme-and-remember ()
    "Run `consult-theme' and persist the chosen theme."
    (interactive)
    (call-interactively 'consult-theme)
    (let ((inhibit-message t)
          (message-log-max nil))
      (remember-last-theme-save)))
  :general
  (gg/leader
    "t" '(:ignore t :which-key "Theme")
    "t h" #'gg/consult-theme-and-remember))

(provide 'elementary-emacs-themes)
;;; elementary-emacs-themes.el ends here
