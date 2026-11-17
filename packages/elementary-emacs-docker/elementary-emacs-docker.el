;;; elementary-emacs-docker.el --- Docker integration -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (elementary-emacs-keys "0.1") (docker "2.0"))
;; Keywords: tools

;;; Commentary:

;; Docker management and Dockerfile mode.

;;; Code:

(require 'elementary-emacs-keys)

(add-to-list 'auto-mode-alist '("\\(Containerfile\\|Dockerfile\\).*" . dockerfile-ts-mode))

(use-package docker
  :general
  (gg/leader
    "k" #'docker))

(provide 'elementary-emacs-docker)
;;; elementary-emacs-docker.el ends here
