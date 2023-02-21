{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.programs.git;
in
  {
    options.modules.programs.git = {
      enable = mkEnableOption "git version control";
    };

    config = mkIf cfg.enable {
      programs.git = {
        enable = true;

        includes = [
          {
            contents = {
              user = {
                name = config.accounts.email.accounts.personal.realName;
                email = config.accounts.email.accounts.personal.address;
              };
            };
          }
          {
            condition = "gitdir:~/School/";
            contents = {
              user = {
                name = config.accounts.email.accounts.school.realName;
                email = config.accounts.email.accounts.school.address;
              };
            };
          }
        ];

        extraConfig = {
          init.defaultBranch = "main";
          credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
          push.autoSetupRemote = true;
        };
      };
    };
  }
