{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.elementary;
let
  cfg = config.elementary.programs.git;
  inherit (config.elementary) user;
in
{
  options.elementary.programs.git = with types; {
    enable = mkEnableOption "git version control";
    userName = mkOpt str user.accounts.fullName "The name to configure git with";
    userEmail = mkOpt str user.accounts.primaryEmailAddress "The email to configure git with";
    signingKey = mkOption {
      description = "The key ID to sign commits with";
      type = nullOr str;
      default = null;
    };
    signByDefault = mkOpt bool true "Whether to sign Git commits using GPG";
    githubUsername = mkOpt str "gekoke" "The GitHub username to use";
  };

  config = mkIf cfg.enable {
    elementary.home = {
      packages = [ pkgs.git-absorb ];
      programs.git = {
        enable = true;
        inherit (cfg) userName userEmail;
        signing = {
          key = cfg.signingKey;
          inherit (cfg) signByDefault;
        };
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
          push.autoSetupRemote = true;
          rerere.enabled = true;
          github.user = cfg.githubUsername;
          diff = {
            colorMoved = true;
            algorithm = "histogram";
          };
          credential.helper = "store";
          gc.auto = 0;
        };
      };
    };
  };
}
