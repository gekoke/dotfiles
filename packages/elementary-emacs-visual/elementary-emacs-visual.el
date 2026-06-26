;;; elementary-emacs-visual.el --- Visual UI bundle -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (auto-olivetti "1.0") (consult "1.0") (dashboard "1.8") (doom-modeline "4.0") (ligature "1.0") (nerd-icons "0.1") (nyan-mode "1.1") (olivetti "2.0") (rainbow-delimiters "2.1") (elementary-emacs-keys "0.1"))
;; Keywords: faces, frames, mode-line

;;; Commentary:

;; Visual UI: modeline, dashboard, fonts, ligatures, indentation guides,
;; and icon associations.

;;; Code:

(require 'elementary-emacs-keys)

(use-package emacs
  :custom
  (inhibit-startup-message t)
  (use-dialog-box nil)
  (initial-scratch-message "")
  (cursor-in-non-selected-windows nil))

(use-package paren
  :hook (after-init . show-paren-mode))

(use-package simple
  :hook (after-init . column-number-mode))

(use-package time
  :hook (after-init . display-time-mode)
  :custom
  (display-time-24hr-format t)
  (display-time-default-load-average nil))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 32)
  (doom-modeline-indent-info t)
  (doom-modeline-modal nil)
  (doom-modeline-check-icon nil)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-workspace-name nil)
  (doom-modeline-buffer-file-name-style 'relative-from-project))

(use-package nyan-mode
  :if (display-graphic-p)
  :hook (doom-modeline-mode . nyan-mode)
  :custom
  (nyan-animation-frame-interval (/ 1.0 20)))

(use-package dashboard
  :demand t
  :after (consult nerd-icons)
  :init
  (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
  :custom
  (dashboard-startup-banner '3)
  (dashboard-set-init-info t)
  (dashboard-center-content t)

  (dashboard-icon-type 'nerd-icons)
  (dashboard-display-icons-p t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)

  (dashboard-items '())
  :config
  (dashboard-setup-startup-hook))

(set-frame-font "VictorMono Nerd Font:size=14:weight=semibold" nil t)

(use-package ligature
  :hook (after-init . global-ligature-mode)
  :config
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ">>=" ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++")))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package olivetti
  :commands (olivetti-mode)
  :custom
  (olivetti-body-width 220)
  :general
  (gg/leader
    "t c" 'olivetti-mode))

(use-package auto-olivetti
  :custom
  (auto-olivetti-enabled-modes '(text-mode prog-mode))
  :general
  (gg/leader
    "t C" 'auto-olivetti-mode))

(use-package nerd-icons
  :demand t
  :config
  (dolist (assoc '(("age" nerd-icons-codicon "nf-cod-gist_secret" :face nil)
                   ("apk" nerd-icons-devicon "nf-dev-android" :face nerd-icons-green)
                   ("chs" nerd-icons-devicon "nf-dev-haskell" :face nerd-icons-purple)
                   ("css" nerd-icons-devicon "nf-dev-css3" :face nerd-icons-blue)
                   ("hs" nerd-icons-devicon "nf-dev-haskell" :face nerd-icons-purple)
                   ("hsc" nerd-icons-devicon "nf-dev-haskell" :face nerd-icons-purple)
                   ("ico" nerd-icons-sucicon "nf-seti-favicon" :face nerd-icons-yellow)
                   ("jar" nerd-icons-devicon "nf-dev-java" :face nerd-icons-red)
                   ("java" nerd-icons-devicon "nf-dev-java" :face nerd-icons-red)
                   ("json" nerd-icons-codicon "nf-cod-json" :face nerd-icons-yellow)
                   ("lhs" nerd-icons-devicon "nf-dev-haskell" :face nerd-icons-purple)
                   ("lock" nerd-icons-faicon "nf-fa-lock" :face nerd-icons-yellow)
                   ("pdf" nerd-icons-faicon "nf-fa-file_pdf_o" :face nerd-icons-red)
                   ("svg" nerd-icons-mdicon "nf-md-svg" :face nerd-icons-yellow)
                   ("ts" nerd-icons-sucicon "nf-seti-typescript" :face nerd-icons-blue)
                   ("toml" nerd-icons-sucicon "nf-seti-typescript" :face nerd-icons-blue)
                   ("txt" nerd-icons-sucicon "nf-seti-text" :face nerd-icons-silver)
                   ("yaml" nerd-icons-sucicon "nf-seti-yml" :face nerd-icons-purple)
                   ("yml" nerd-icons-sucicon "nf-seti-yml" :face nerd-icons-purple)))
    (add-to-list 'nerd-icons-extension-icon-alist assoc))

  (dolist (regexp '("^TAGS$"
                    "^TODO$"
                    "^LICENSE$"
                    "^readme"))
    (setq nerd-icons-regexp-icon-alist
          (cl-remove-if (lambda (entry) (string= (car entry) regexp))
                        nerd-icons-regexp-icon-alist))))

(defun gg/set-background-opacity (opacity)
  "Interactively change the current frame's OPACITY."
  (interactive
   (list (read-number "Opacity (0-100): "
                      (or (frame-parameter nil 'alpha)
                          100))))
  (set-frame-parameter nil 'alpha-background opacity))

(gg/leader
  "t o" #'gg/set-background-opacity)

(provide 'elementary-emacs-visual)
;;; elementary-emacs-visual.el ends here
