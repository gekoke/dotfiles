;;; elementary-emacs-agents.el --- AI coding agent support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (eca "0.1") (elementary-emacs-keys "0.1"))
;; Keywords: tools

;;; Commentary:

;; ECA (Editor Code Assistant) integration: editor-agnostic LLM server with
;; tool/MCP support, exposed through the `eca-emacs' client.

;;; Code:

(require 'elementary-emacs-keys)

(use-package eca
  :general
  (gg/leader
    "a"  '(:ignore t :which-key "Agents")
    "a a" #'eca
    "a c" #'eca-chat-select-agent
    "a m" #'eca-chat-select-model
    "a s" #'eca-stop
    "a r" #'eca-restart
    "a w" #'eca-workspaces))

(provide 'elementary-emacs-agents)
;;; elementary-emacs-agents.el ends here
