;;; elementary-emacs-prelude.el --- Baseline Emacs defaults -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (undo-tree "0.7"))
;; Keywords: convenience

;;; Commentary:

;; Provides the opinionated baseline Emacs defaults shared by all
;; Elementary Emacs configurations: backup/autosave layout, GC tuning,
;; built-in mode tweaks, line numbers and `hl-line-mode' for code
;; buffers, and lazy activation of `editorconfig', `undo-tree',
;; `display-time-mode', `winner-mode', and `repeat-mode'.

;;; Code:

(require 'use-package)

(setq gc-cons-threshold 1000000000)
(setq read-process-output-max (* 1024 1024))

(setq-default tab-width 4)

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
  (setq kill-buffer-query-functions nil))

(use-package undo-tree
  :hook (after-init . global-undo-tree-mode)
  :custom
  (undo-tree-enable-undo-in-region t)
  (undo-tree-history-directory-alist
   `(("." . ,(concat user-emacs-directory "undo-tree-history")))))

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

(setq backup-by-copying t
      delete-old-versions t
      version-control t
      kept-new-versions 8
      kept-old-versions 8)

(setq create-lockfiles nil)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-message t)
(setq use-dialog-box nil)
(setq initial-scratch-message "")
(save-place-mode 1)
(setq-default cursor-in-non-selected-windows nil)
(recentf-mode 1)
(savehist-mode 1)
(global-auto-revert-mode 1)
(column-number-mode)

(setq display-line-numbers-type 'relative)

(defun elementary-emacs-prelude--enable-line-numbers ()
  "Enable relative `display-line-numbers-mode' in the current buffer."
  (display-line-numbers-mode 1))

(defun elementary-emacs-prelude--enable-hl-line ()
  "Enable `hl-line-mode' in the current buffer."
  (hl-line-mode 1))

(defun elementary-emacs-prelude--enable-hs-minor ()
  "Enable `hs-minor-mode' in the current buffer."
  (hs-minor-mode 1))

(dolist (hook '(prog-mode-hook
                conf-mode-hook
                json-ts-mode-hook
                text-mode-hook))
  (add-hook hook #'elementary-emacs-prelude--enable-line-numbers)
  (add-hook hook #'elementary-emacs-prelude--enable-hl-line))

(dolist (hook '(prog-mode-hook
                conf-mode-hook
                json-ts-mode-hook))
  (add-hook hook #'elementary-emacs-prelude--enable-hs-minor))

(electric-indent-mode +1)
(electric-pair-mode +1)
(setq-default indent-tabs-mode nil)
(setq-default truncate-lines t)
(show-paren-mode 1)

(setq even-window-sizes nil)

(add-to-list 'display-buffer-alist
             '("\\*compilation*"
               nil
               (reusable-frames . t)))

;; Don't make new frame for ediff - why would I want that?!
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(winner-mode +1)
(repeat-mode +1)

(provide 'elementary-emacs-prelude)
;;; elementary-emacs-prelude.el ends here
