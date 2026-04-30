;;; elementary-emacs-terminal.el --- Terminal integration -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (evil "1.15") (general "0.1") (vterm "0.0.2") (vterm-toggle "0.1") (elementary-emacs-keys "0.1"))
;; Keywords: terminals

;;; Commentary:

;; Terminal integration for Elementary Emacs: vterm and vterm-toggle
;; with leader bindings, plus a `gg/cmatrix' helper that arranges four
;; vterm windows in a 2x2 grid.

;;; Code:

(require 'elementary-emacs-keys)

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

(provide 'elementary-emacs-terminal)
;;; elementary-emacs-terminal.el ends here
