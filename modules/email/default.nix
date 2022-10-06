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
      msmtp.enable = true;
      emacs.extraPackages = epkgs: with pkgs; [ pkgs.mu ];
    };

    accounts.email = {
      accounts = {
        personal = {
          primary = true;
          address = "gekoke@lazycantina.xyz";
          aliases = [
            "mailbox@lazycantina.xyz"
            "gekoke@lazycantina.xyz"
          ];
          smtp.host = "smtp.fastmail.com";
          imap.host = "imap.fastmail.com";
          userName = "mailbox@lazycantina.xyz";
          passwordCommand = "cat ~/.mailpass";
          mu.enable = true;
          mbsync = {
            enable = true;
            create = "maildir";
          };
        };
      };
    };

    services = {
      mbsync = {
        enable = true;
        preExec = "${pkgs.isync}/bin/mbsync -Ha";
        postExec = "${pkgs.mu}/bin/mu index -m ${config.accounts.email.maildirBasePath}";
      };
    };
  };
}
