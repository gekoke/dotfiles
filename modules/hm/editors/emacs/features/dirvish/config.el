(use-package! dirvish
  :init (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("c" "~/.config/"                  "Config")
     ("t" "~/.local/share/Trash/files/" "Trash")))
  :config
  (dirvish-peek-mode)
  (dirvish-side-follow-mode)
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes
        '(all-the-icons file-time file-size subtree-state vc-state git-msg))
  (setq delete-by-moving-to-trash t)
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  (map! :leader "r a" #'dirvish)
  (map! :leader "o p" #'dirvish-side)
  (map! :map dirvish-mode-map :localleader "k" #'dired-create-directory)
  (map! :map dirvish-mode-map :localleader "f" #'dired-create-empty-file)
  (map! :map dirvish-mode-map :ng "h"   #'dired-up-directory)
  (map! :map dirvish-mode-map :ng "q"   #'dirvish-quit)
  (map! :map dirvish-mode-map :ng "l"   #'dired-find-file)
  (map! :map dirvish-mode-map :ng "v"   #'dirvish-vc-menu)
  (map! :map dirvish-mode-map :ng "a"   #'dirvish-quick-access)
  (map! :map dirvish-mode-map :ng "f"   #'dirvish-file-info-menu)
  (map! :map dirvish-mode-map :ng "s"   #'dirvish-quicksort)
  (map! :map dirvish-mode-map :ng "C-i" #'dirvish-history-go-forward)
  (map! :map dirvish-mode-map :ng "C-o" #'dirvish-history-go-backward)
  (map! :map dirvish-mode-map :ng "y"   #'dirvish-yank-menu)
  :bind                           ; Bind `dirvish|dirvish-side|dirvish-dwim' as you see fit
  (("C-c f" . dirvish-fd)
   :map dirvish-mode-map          ; Dirvish inherits `dired-mode-map'
   ("^"   . dirvish-history-last)
   ("$"   . dirvish-history-jump) ; remapped `describe-mode'
   ("TAB" . dirvish-subtree-toggle)
   ("M-l" . dirvish-ls-switches-menu)
   ("M-m" . dirvish-mark-menu)
   ("M-n" . dirvish-narrow)
   ("M-t" . dirvish-layout-toggle)
   ("M-s" . dirvish-setup-menu)
   ("M-e" . dirvish-emerge-menu)
   ("M-j" . dirvish-fd-jump)))
