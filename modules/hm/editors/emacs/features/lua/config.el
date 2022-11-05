; For some reason the doom module't
; that should add a lsp hook doesn't work
; so we add this here
; 2022-11-05T03:11:53+0200
(add-hook 'lua-mode-hook #'lsp!)
