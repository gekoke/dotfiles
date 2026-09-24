;;; elementary-emacs-csharp.el --- C# language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (elementary-emacs-lsp "0.1"))
;; Keywords: languages

;;; Commentary:

;; C# language support.

;;; Code:

(require 'elementary-emacs-lsp)

(defun gg/roslyn-server-command ()
  "Command for Microsoft.CodeAnalysis.LanguageServer."
  (list lsp-roslyn-dotnet-executable
        lsp-roslyn-server-dll-override-path
        "--autoLoadProjects"
        "--stdio"))

(use-package lsp-roslyn
  :custom
  (lsp-roslyn-dotnet-executable "@dotnet@")
  (lsp-roslyn-server-dll-override-path "@roslynLsDll@")
  :config
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection #'gg/roslyn-server-command)
    ;; Higher priority than: csharp-roslyn (0), omnisharp is (-1)
    ;; https://github.com/emacs-lsp/lsp-mode/blob/6bfc593d7b1bc0dd656f09ffce52cc085ebced05/clients/lsp-roslyn.el#L344
    ;; https://github.com/emacs-lsp/lsp-mode/blob/6bfc593d7b1bc0dd656f09ffce52cc085ebced05/clients/lsp-csharp.el#L438
    :priority 1
    :server-id 'csharp-roslyn-stdio
    :activation-fn (lsp-activate-on "csharp")
    :notification-handlers (lsp-ht ("workspace/projectInitializationComplete"
                                    #'lsp-roslyn--on-project-initialization-complete))
    :path->uri-fn #'lsp-roslyn--path-to-uri
    :uri->path-fn #'lsp-roslyn--uri-to-path)))

(defun gg/roslyn--resync-document ()
  "Resend the whole buffer to Roslyn as a didClose/didOpen pair."
  (lsp-notify "textDocument/didClose"
              (list :textDocument (lsp--text-document-identifier)))
  (lsp-notify "textDocument/didOpen"
              (list :textDocument
                    (list :uri (lsp--buffer-uri)
                          :languageId (lsp-buffer-language)
                          :version lsp--cur-version
                          :text (lsp--buffer-content)))))

(define-advice lsp--text-document-content-change-event
    (:around (fn start end length) gg/roslyn-never-send-rangeless)
  "Reopen the document instead of sending a change with no range.
lsp-mode falls back to a whole-buffer change event when it cannot pin down
what moved (reverts, undo, applying an edit), and Roslyn crashes on any
change event without a range."
  (let ((event (funcall fn start end length)))
    (if (or (plist-get event :range)
            (not (derived-mode-p 'csharp-ts-mode)))
        event
      (gg/roslyn--resync-document)
      (let ((origin (lsp--point-to-position (point-min))))
        (list :range (lsp--range origin origin) :rangeLength 0 :text "")))))

(defun gg/csharp-disable-document-color ()
  "Stop asking Roslyn for colour swatches.
It has no handler for C# and logs an error every time."
  (setq-local lsp-enable-text-document-color nil))

(use-package csharp-ts-mode
  :mode ("\\.cs\\'" . csharp-ts-mode)
  :hook ((csharp-ts-mode . gg/csharp-disable-document-color)
         (csharp-ts-mode . lsp-deferred))
  :custom
  (lsp-disabled-clients '(csharp-ls csharp-roslyn omnisharp))
  :general
  (gg/leader csharp-ts-mode-map
    "m s" #'lsp-roslyn-open-solution-file))

(provide 'elementary-emacs-csharp)
;;; elementary-emacs-csharp.el ends here
