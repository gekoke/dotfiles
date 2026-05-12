;;; elementary-emacs-markdown.el --- Markdown language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (markdown-mode "2.7"))
;; Keywords: languages

;;; Commentary:

;; Markdown major mode with native code block fontification.

;;; Code:

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)
  :custom
  (markdown-fontify-code-blocks-natively t)
  :config
  (add-to-list 'markdown-code-lang-modes '("py" . python-mode))
  (add-to-list 'markdown-code-lang-modes '("python" . python-mode)))

(provide 'elementary-emacs-markdown)
;;; elementary-emacs-markdown.el ends here
