;;; elementary-emacs-completion.el --- Completion stack -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (cape "1.5") (consult "1.0") (corfu "1.5") (embark "1.0") (embark-consult "1.0") (general "0.1") (marginalia "1.6") (nerd-icons-completion "0.1") (nerd-icons-corfu "0.2") (orderless "1.1") (rg "2.3") (vertico "1.7") (wgrep "3.0") (which-key "3.6") (elementary-emacs-keys "0.1"))
;; Keywords: convenience, abbrev

;;; Commentary:

;; Minibuffer and at-point completion for Elementary Emacs:
;; vertico/marginalia/orderless/embark for the minibuffer side,
;; consult for narrowing commands and previews,
;; corfu/cape/nerd-icons-corfu for in-buffer completion,
;; which-key/rg/wgrep for discoverability and grep-based workflows,
;; plus project.el integration with consult-driven file finding.

;;; Code:

(require 'elementary-emacs-keys)

(use-package which-key
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 0.4))

(use-package rg :defer t)
(use-package wgrep :defer t)

(use-package embark
  :general
  (general-def
    "M-e" #'embark-export))

(use-package vertico
  :hook (after-init . vertico-mode)
  :custom
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (vertico-cycle t)
  :general
  (general-def minibuffer-local-map
    "M-j" #'next-line-or-history-element
    "M-k" #'previous-line-or-history-element))

(use-package marginalia
  :hook (after-init . marginalia-mode)
  :general
  (general-def minibuffer-local-map "M-A" #'marginalia-cycle))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package orderless
  :defer t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package project
  :defer t
  :custom
  (project-switch-commands
   '((project-find-file "File" "f")
     (project-find-dir "Directory" "d")
     (consult-ripgrep "Search" "/")))
  :general
  (gg/leader
    "SPC" #'project-find-file
    "p p" #'project-switch-project))

(use-package consult
  :demand t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq project-read-file-name-function #'consult-project-find-file-with-preview)

  (defun consult-project-find-file-with-preview (prompt all-files &optional pred hist _mb)
    (let ((prompt (if (and all-files
                           (file-name-absolute-p (car all-files)))
                      prompt
                    (concat prompt
                            (format " in %s"
                                    (consult--fast-abbreviate-file-name default-directory)))))
          (minibuffer-completing-file-name t))
      (consult--read (mapcar
                      (lambda (file)
                        (file-relative-name file))
                      all-files)
                     :state (consult--file-preview)
                     :prompt (concat prompt ": ")
                     :require-match t
                     :history hist
                     :category 'file
                     :predicate pred)))
  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  :config
  (defun gg/consult-buffer-vterm ()
    "Open `consult-buffer' pre-filtered to vterm buffers."
    (interactive)
    (minibuffer-with-setup-hook
        (lambda () (insert "vterm"))
      (consult-buffer)))
  :general
  (gg/leader
    "b" #'consult-buffer
    "o v" #'gg/consult-buffer-vterm
    "/" #'consult-ripgrep))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package cape
  :init
  (setq-default completion-at-point-functions (list
                                               #'cape-file
                                               #'cape-dabbrev
                                               #'cape-keyword))
  (defun gg/setup-elisp-mode-capf ()
    (require 'cape)
    (setq-local completion-at-point-functions (list
                                               (cape-capf-nonexclusive #'elisp-completion-at-point)
                                               #'cape-file
                                               #'cape-dabbrev
                                               #'cape-keyword)))
  :hook
  (emacs-lisp-mode . gg/setup-elisp-mode-capf))

(use-package corfu
  :hook (after-init . global-corfu-mode)
  :custom
  (completion-ignore-case t)
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-delay (/ 1.0 60))
  (corfu-auto-prefix 1)
  (corfu-popupinfo-mode t)
  (corfu-min-width 40)
  (corfu-popupinfo-delay '(0 . 0)))

(use-package emacs
  :after corfu
  :custom
  (read-extended-command-predicate #'command-completion-default-include-p)
  (tab-always-indent 'complete))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(provide 'elementary-emacs-completion)
;;; elementary-emacs-completion.el ends here
