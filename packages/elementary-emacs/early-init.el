;; Make sure we can only install packages through Nix.
(setq use-package-ensure-function 'ignore)
(setq package-archives nil)

;; Fix lag on PGTK build.
(setq-default pgtk-wait-for-event-timeout 0)

;; Redirect runtime writes off the read-only Nix store.
(setq user-emacs-directory (expand-file-name "~/.emacs.d/"))
