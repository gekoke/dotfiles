;;; elementary-emacs-prelude.el --- Baseline Emacs defaults -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (undo-tree "0.7"))
;; Keywords: convenience

;;; Commentary:

;; Sensible baseline defaults shared by all Elementary Emacs configurations.

;;; Code:

(require 'use-package)

(use-package emacs
  :custom
  (gc-cons-threshold 1000000000)
  (read-process-output-max (* 1024 1024))
  (inhibit-startup-message t)
  (use-dialog-box nil)
  (initial-scratch-message "")
  (cursor-in-non-selected-windows nil)
  (truncate-lines t)
  (indent-tabs-mode nil)
  (tab-width 4)
  (create-lockfiles nil)
  (display-line-numbers-type 'relative)
  (even-window-sizes nil)
  (kill-buffer-query-functions nil)
  :init
  (defalias 'yes-or-no-p 'y-or-n-p))

(use-package time
  :hook (after-init . display-time-mode)
  :custom
  (display-time-24hr-format t)
  (display-time-default-load-average nil))

(use-package calendar
  :defer t
  :custom
  (calendar-week-start-day 1))

(use-package files
  :custom
  (backup-by-copying t)
  (delete-old-versions t)
  (version-control t)
  (kept-new-versions 8)
  (kept-old-versions 8)
  :config
  (let ((backup-dir "~/.local/state/emacs/backups")
        (auto-saves-dir "~/.local/state/emacs/autosaves"))
    (dolist (dir (list backup-dir auto-saves-dir))
      (unless (file-directory-p dir)
        (make-directory dir t)))
    (setq backup-directory-alist `(("." . ,backup-dir))
          auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
          auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
          tramp-backup-directory-alist `((".*" . ,backup-dir))
          tramp-auto-save-directory auto-saves-dir)))

(use-package undo-tree
  :hook (after-init . global-undo-tree-mode)
  :custom
  (undo-tree-enable-undo-in-region t)
  (undo-tree-history-directory-alist
   `(("." . ,(concat user-emacs-directory "undo-tree-history")))))

(use-package saveplace      :hook (after-init . save-place-mode))
(use-package recentf        :hook (after-init . recentf-mode))
(use-package savehist       :hook (after-init . savehist-mode))
(use-package autorevert     :hook (after-init . global-auto-revert-mode))
(use-package simple         :hook (after-init . column-number-mode))
(use-package elec-pair      :hook (after-init . electric-pair-mode))
(use-package electric       :hook (after-init . electric-indent-mode))
(use-package paren          :hook (after-init . show-paren-mode))
(use-package winner         :hook (after-init . winner-mode))
(use-package repeat         :hook (after-init . repeat-mode))

(use-package scroll-bar     :hook (after-init . (lambda () (scroll-bar-mode -1))))
(use-package tool-bar       :hook (after-init . (lambda () (tool-bar-mode -1))))
(use-package tooltip        :hook (after-init . (lambda () (tooltip-mode -1))))
(use-package menu-bar       :hook (after-init . (lambda () (menu-bar-mode -1))))

(use-package display-line-numbers
  :hook ((prog-mode conf-mode json-ts-mode text-mode) . display-line-numbers-mode))

(use-package hl-line
  :hook ((prog-mode conf-mode json-ts-mode text-mode) . hl-line-mode))

(use-package hideshow
  :hook ((prog-mode conf-mode json-ts-mode) . hs-minor-mode))

(use-package window
  :custom
  (display-buffer-alist
   '(("\\*compilation*" nil (reusable-frames . t)))))

(use-package ediff
  :defer t
  :custom
  (ediff-window-setup-function 'ediff-setup-windows-plain))

(provide 'elementary-emacs-prelude)
;;; elementary-emacs-prelude.el ends here
