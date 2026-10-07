;;; elementary-emacs-agents.el --- AI coding agent support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (agent-shell "0.70") (elementary-emacs-keys "0.1"))
;; Keywords: tools

;;; Commentary:

;; Elementary agents

;;; Code:

(require 'elementary-emacs-keys)

(use-package agent-shell
  :custom
  (agent-shell-activity-group-expand-by-default 'latest)
  (agent-shell-inhibit-system-sleep nil)
  (agent-shell-thought-process-expand-by-default t)
  (agent-shell-tool-use-expand-by-default t)
  (agent-shell-user-message-expand-by-default t)
  :general
  (general-def
    :states 'normal
    :keymaps '(agent-shell-mode-map agent-shell-viewport-view-mode-map)
    "za" #'agent-shell-ui-toggle-fragment
    "zi" #'agent-shell-ui-toggle-all-fragments)
  (general-def
    :states 'normal
    :keymaps 'agent-shell-mode-map
    "RET" #'agent-shell-submit
    "gq" #'agent-shell-prompt-queue
    "gQ" #'agent-shell-prompt-queue-remove)
  (general-def
    :states '(normal insert)
    :keymaps 'agent-shell-mode-map
    "C-<return>" #'agent-shell-submit))

(provide 'elementary-emacs-agents)
;;; elementary-emacs-agents.el ends here
