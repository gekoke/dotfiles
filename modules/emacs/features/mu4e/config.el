(after! mu4e
  (setq message-send-mail-function 'smtpmail-send-it)
  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "Personal"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/personal" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "gekoke@lazycantina.xyz")
                  (user-full-name . "gekoke")
                  (smtpmail-smtp-server . "smtp.fastmail.com")
                  (smtpmail-smtp-service . 465)
                  (smtpmail-stream-type . ssl)
                  (mu4e-sent-folder . "/personal/Sent")
                  (mu4e-drafts-folder . "/personal/Drafts")
                  (mu4e-trash-folder . "/personal/Trash"))))))
