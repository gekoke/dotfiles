;;; elementary-emacs-keys.el --- Leader-key definers -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (general "0.1"))
;; Keywords: convenience

;;; Commentary:

;; Defines the `gg/leader' and `gg/local' key-definers used throughout
;; the Elementary Emacs configuration.  Loading this file is a
;; prerequisite for any other Elementary Emacs package that binds
;; leader keys, since the definer macros must be available at
;; byte-compile time of the consuming package.

;;; Code:

(require 'general)

;;;###autoload
(general-create-definer gg/leader
  :states '(normal insert visual emacs)
  :prefix "SPC"
  :global-prefix "C-SPC")

;;;###autoload
(general-create-definer gg/local
  :states '(normal insert visual emacs)
  :prefix "SPC m"
  :global-prefix "C-SPC m")

(provide 'elementary-emacs-keys)
;;; elementary-emacs-keys.el ends here
