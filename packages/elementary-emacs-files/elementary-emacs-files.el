;;; elementary-emacs-files.el --- File browsing and dired -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (dired-gitignore "0.4") (diredfl "0.6") (dirvish "2.2") (general "0.1") (nerd-icons "0.1") (elementary-emacs-keys "0.1"))
;; Keywords: files, convenience

;;; Commentary:

;; File browsing for Elementary Emacs: dirvish (with quick-access
;; entries, mode-line/header formats, attribute selections, and a
;; comprehensive evil keymap), dirvish-side, dired-gitignore, diredfl,
;; and dired/dired-x defaults.

;;; Code:

(require 'elementary-emacs-keys)

(use-package dirvish
  :hook (after-init . dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries
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
    "h"    #'dired-up-directory
    "l"    #'dired-find-file
    "a"    #'dirvish-quick-access
    "f"    #'dirvish-file-info-menu
    "y"    #'dirvish-yank-menu
    "^"    #'dirvish-history-last
    "$"    #'dirvish-history-jump
    "s"    #'dirvish-quicksort
    "v"    #'dirvish-vc-menu
    "."    #'dired-omit-mode
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

(provide 'elementary-emacs-files)
;;; elementary-emacs-files.el ends here
