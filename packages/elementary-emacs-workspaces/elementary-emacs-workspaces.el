;;; elementary-emacs-workspaces.el --- Window and workspace management -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (ace-window "0.10") (dashboard "1.8") (eyebrowse "0.7") (general "0.1") (elementary-emacs-keys "0.1"))
;; Keywords: convenience, frames

;;; Commentary:

;; Window and workspace management for Elementary Emacs: ace-window
;; for jumping/swapping/deleting windows by hint, and eyebrowse for
;; numbered window-configuration workspaces with leader bindings and
;; magit-section integration.

;;; Code:

(require 'elementary-emacs-keys)

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

(provide 'elementary-emacs-workspaces)
;;; elementary-emacs-workspaces.el ends here
