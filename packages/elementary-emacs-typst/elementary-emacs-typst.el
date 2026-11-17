;;; elementary-emacs-typst.el --- Typst language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (elementary-emacs-lsp "0.1") (typst-ts-mode "0.10"))
;; Keywords: languages

;;; Commentary:

;; Typst major mode and tinymist.

;;; Code:

(require 'elementary-emacs-lsp)

(use-package typst-ts-mode
  :custom
  (typst-ts-mode-indent-offset 2)
  :config
  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection "tinymist")
      :activation-fn (lsp-activate-on "typst")
      :server-id 'typst-lsp))))

(provide 'elementary-emacs-typst)
;;; elementary-emacs-typst.el ends here
