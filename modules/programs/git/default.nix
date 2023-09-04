{ config, lib, ... }:
with lib;
let
  cfg = config.elementary.programs.git;
  gpg = config.elementary.security.gpg;
  user = config.elementary.user;
in
{
  options.elementary.programs.git = with types; {
    enable = mkEnableOption "git version control";
    userName = mkOpt types.str user.accounts.fullName "The name to configure git with";
    userEmail = mkOpt types.str user.accounts.primaryEmailAddress "The email to configure git with";
    signingKey = mkOpt types.str "D55B9940B30A04A2" "The key ID to sign commits with";
    githubUsername = mkOpt types.str "gekoke" "The GitHub username to use";
  };

  config = mkIf cfg.enable {
    elementary.home = {
      programs.git = {
        enable = true;
        inherit (cfg) userName userEmail;
        signing = {
          key = cfg.signingKey;
          signByDefault = mkIf gpg.enable true;
        };
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
          push.autoSetupRemote = true;
          github.user = cfg.githubUsername;
        };
      };
    };
  };
}
