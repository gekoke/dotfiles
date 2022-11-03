(after! (dired ranger)
  (setq ranger-override-dired 'ranger))

(map! :map ranger-mode-map
      :m  "; ;" 'dired-create-empty-file)
(map! :localleader
      (:map ranger-mode-map
            "k" #'dired-create-directory))
