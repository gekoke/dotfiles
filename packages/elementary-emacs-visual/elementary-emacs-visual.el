;;; elementary-emacs-visual.el --- Visual UI bundle -*- lexical-binding: t; -*-

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "30.1") (consult "1.0") (dashboard "1.8") (doom-modeline "4.0") (general "0.1") (indent-bars "0.8") (ligature "1.0") (nerd-icons "0.1") (nyan-mode "1.1") (olivetti "2.0") (rainbow-delimiters "2.1") (elementary-emacs-keys "0.1"))
;; Keywords: faces, frames, mode-line

;;; Commentary:

;; Visual UI configuration for Elementary Emacs: doom-modeline (with
;; nyan-mode in the modeline), the dashboard splash buffer, font and
;; ligature setup, rainbow delimiters, indent bars, olivetti
;; (per-buffer and globalized prog-mode variant), nerd-icons file
;; associations, whitespace visualization, and a frame
;; opacity helper.

;;; Code:

(require 'elementary-emacs-keys)

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

(set-frame-font "-IBM -BlexMono Nerd Font-bold-normal-normal-*-*-*-*-*-m-0-iso10646-1" nil t)

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
  :commands (olivetti-mode prog-olivetti-mode global-prog-olivetti-mode)
  :init
;;;###autoload
  (define-minor-mode prog-olivetti-mode
    "Minor mode to enable `olivetti-mode' in `prog-mode' derived buffers."
    (add-hook 'prog-mode-hook #'olivetti-mode))

;;;###autoload
  (define-globalized-minor-mode global-prog-olivetti-mode
    prog-olivetti-mode
    (lambda ()
      (when (derived-mode-p 'prog-mode)
        (olivetti-mode 1))))
  :custom
  (olivetti-body-width 220)
  :general
  (gg/leader
    "t c" 'olivetti-mode
    "t C" 'global-prog-olivetti-mode))

(use-package whitespace
  :defer t
  :init
  (define-global-minor-mode gg/global-whitespace-mode whitespace-mode
    (lambda ()
      (when (derived-mode-p
             'prog-mode
             'yaml-mode
             'markdown-mode)
        (whitespace-mode))))
  :custom
  (whitespace-display-mappings
   '((space-mark 32
                [183]
                [46])
    (space-mark 160
                [164]
                [95])
    (newline-mark 10
                  [8629 10])
    (tab-mark 9
              [187 9]
              [92 9])))
  (whitespace-style
   '(face tabs spaces trailing space-before-tab indentation empty space-after-tab space-mark tab-mark))
  :general
  (gg/leader
    "e w" #'gg/global-whitespace-mode))

(use-package indent-bars
  :demand t
  :hook (after-init . gg/global-indent-bars-mode)
  :init
  (define-global-minor-mode gg/global-indent-bars-mode indent-bars-mode
    (lambda ()
      (when (and (not (derived-mode-p 'emacs-lisp-mode))
                 (derived-mode-p
                  'prog-mode
                  'yaml-mode
                  'markdown-mode))
        (let ((max-lisp-eval-depth (expt 2 14)))
          (indent-bars-mode)))))
  :config
  (require 'indent-bars-ts)
  :custom
  (indent-bars-pattern ".")
  (indent-bars-highlight-current-depth '(:face default :blend 0.4))
  (indent-bars-width-frac 0.1)
  (indent-bars-pad-frac 0.1)
  (indent-bars-zigzag nil)
  (indent-bars-color-by-depth nil)

  (indent-bars-display-on-blank-lines t)
  (indent-bars-starting-column 0)
  (indent-bars-treesit-support t)
  :general
  (gg/leader
    "e i" #'gg/global-indent-bars-mode))

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
