(package! git-auto-commit-mode)
(package! org-contacts)
(package! olivetti)

;; Fix for https://github.com/doomemacs/doomemacs/issues/6425
(package! transient
      :pin "c2bdf7e12c530eb85476d3aef317eb2941ab9440"
      :recipe (:host github :repo "magit/transient"))
(package! with-editor
          :pin "bbc60f68ac190f02da8a100b6fb67cf1c27c53ab"
          :recipe (:host github :repo "magit/with-editor"))
;; endfix

; From https://github.com/iyefrat/doom-emacs/commit/bd944dc318efe2dfb00c1107ca6d70797dad1331
; Due to https://github.com/doomemacs/doomemacs/issues/7191
(package! code-review :recipe (:files ("graphql" "code-review*.el"))
    :pin "26f426e99221a1f9356aabf874513e9105b68140")
    ; HACK closql c3b34a6 breaks code-review wandersoncferreira/code-review#245,
    ; and the current forge commit (but forge does have an upstream fix),
    ; pinned as a temporary measure to prevent user breakages
(package! closql :pin "0a7226331ff1f96142199915c0ac7940bac4afdd")

(load! "~/.config/doom/temp-packages.el" nil t)

