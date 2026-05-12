;;; elementary-emacs-web.el --- Web language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (web-mode "17.3") (lsp-tailwindcss "1.0") (elementary-emacs-lsp "0.1"))
;; Keywords: languages

;;; Commentary:

;; Web stack: HTML/CSS/JSON/TypeScript/JavaScript/Tailwind.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package web-mode
  :mode
  ("\\.phtml\\'" . web-mode)
  ("\\.tpl\\.php\\'" . web-mode)
  ("\\.[agj]sp\\'" . web-mode)
  ("\\.as[cp]x\\'" . web-mode)
  ("\\.erb\\'" . web-mode)
  ("\\.mustache\\'" . web-mode)
  ("\\.djhtml\\'" . web-mode)
  :hook
  (web-mode . lsp-deferred)
  (web-mode . (lambda ()
                (progn
                  (require 'sgml-mode)
                  (sgml-electric-tag-pair-mode))))
  (web-mode . (lambda () (electric-pair-local-mode -1)))
  :custom
  (web-mode-script-padding 4)
  (web-mode-enable-auto-pairing t)
  (web-mode-enable-auto-opening t)
  (web-mode-enable-auto-quoting t))

(use-package html-ts-mode
  :mode
  ("\\.html\\'" . html-ts-mode)
  :hook
  (html-ts-mode . lsp-deferred))

(use-package lsp-tailwindcss
  :after lsp-mode
  :init
  (setq lsp-tailwindcss-add-on-mode t))

(use-package typescript-ts-mode
  :mode
  ("\\.ts\\'" . typescript-ts-mode)
  ("\\.tsx\\'" . tsx-ts-mode)
  :hook
  (typescript-ts-mode . lsp)
  (tsx-ts-mode . lsp)
  :config
  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp--formatting-indent-alist '(tsx-ts-mode . typescript-ts-mode-indent-offset))))

(use-package lsp-javascript
  :after lsp-mode
  :custom
  (lsp-typescript-references-code-lens-enabled t)
  (lsp-typescript-implementations-code-lens-enabled t))

(use-package js
  :hook
  (js-ts-mode . lsp)
  :mode
  ("\\.mjs\\'" . js-ts-mode)
  ("\\.js\\'" . js-ts-mode)
  :custom
  (js-indent-level 2))

(use-package json-ts-mode
  :hook
  (json-ts-mode . lsp))

(provide 'elementary-emacs-web)
;;; elementary-emacs-web.el ends here
