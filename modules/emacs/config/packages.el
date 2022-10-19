(package! git-auto-commit-mode)
(package! org-contacts)

(let ((temp-packages "~/.config/doom/temp-packages.el"))
  (if (file-exists-p temp-packages)
      (load! temp-packages)))
