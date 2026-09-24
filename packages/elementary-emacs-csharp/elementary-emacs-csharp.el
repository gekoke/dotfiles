;;; elementary-emacs-csharp.el --- C# language support -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (elementary-emacs-lsp "0.1"))
;; Keywords: languages

;;; Commentary:

;; C# major mode and LSP wiring.  We register our own Roslyn client because
;; lsp-mode's `lsp-roslyn' launches the server without --stdio or --pipe, and
;; Roslyn 5.x refuses to start without one of them.

;;; Code:

(require 'elementary-emacs-lsp)

(defun gg/roslyn-server-command ()
  "Command line for Microsoft.CodeAnalysis.LanguageServer.
Without --autoLoadProjects the server loads nothing until you open a .sln
by hand."
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
    ;; Outrank lsp-mode's own C# clients: csharp-roslyn is 0, omnisharp is -1.
    ;; https://github.com/emacs-lsp/lsp-mode/blob/6bfc593d7b1bc0dd656f09ffce52cc085ebced05/clients/lsp-roslyn.el#L344
    ;; https://github.com/emacs-lsp/lsp-mode/blob/6bfc593d7b1bc0dd656f09ffce52cc085ebced05/clients/lsp-csharp.el#L438
    :priority 1
    :server-id 'csharp-roslyn-stdio
    :activation-fn (lsp-activate-on "csharp")
    :notification-handlers (lsp-ht ("workspace/projectInitializationComplete"
                                    #'lsp-roslyn--on-project-initialization-complete))
    :path->uri-fn #'lsp-roslyn--path-to-uri
    :uri->path-fn #'lsp-roslyn--uri-to-path)))

(defun gg/csharp-disable-document-color ()
  "Stop asking Roslyn for colour swatches.
It has no handler for C# and logs an error every time we ask."
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
