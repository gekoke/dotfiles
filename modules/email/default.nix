{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.email;
  mailDir = "~/.maildir";
in {
  options.modules.email = {
    enable = mkEnableOption "email";
  };

  config = mkIf cfg.enable {
    programs = {
      mu.enable = true;
      mbsync.enable = true;
      notmuch = {
        enable = true;
        hooks.preNew = "mbsync -a";
      };
      emacs.extraPackages = epkgs: with pkgs; [ pkgs.mu ];
    };

    accounts.email = {
      accounts = {
        personal = {
          primary = true;
          realName = "gekoke";
          address = "gekoke@lazycantina.xyz";
          smtp.host = "smtp.fastmail.com";
          imap.host = "imap.fastmail.com";
          userName = "mailbox@lazycantina.xyz";
          passwordCommand = "cat ~/.mailpass";
          mu.enable = true;
          notmuch.enable = true;
          mbsync = {
            enable = true;
            create = "maildir";
          };
          imapnotify = {
            enable = true;
            boxes = map (box: "personal/" + box) [
              "Archive"
              "Bills"
              "Drafts"
              "Inbox"
              "Sent"
              "Spam"
              "Trash"
            ];
            onNotify = "touch ~/worked1fil && ${pkgs.isync}/bin/mbsync -a";
            onNotifyPost = "touch ~/workedfile && ${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived'";
          };
        };
      };
    };

    services = {
      imapnotify.enable = true;
      mbsync.enable = true;
    };
  };
}
