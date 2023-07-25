{ config, lib, ... }:
with lib;
let
  cfg = config.plusultra.programs.git;
  gpg = config.plusultra.security.gpg;
  user = config.plusultra.user;
in
{
  options.plusultra.programs.git = with types; {
    enable = mkEnableOption "git version control";
    userName = mkOpt types.str user.fullName "The name to configure git with";
    userEmail = mkOpt types.str user.primaryEmailAddress "The email to configure git with";
    signingKey = mkOpt types.str "D55B9940B30A04A2" "The key ID to sign commits with.";
  };

  config = mkIf cfg.enable {
    plusultra.home = {
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
        };
      };
    };
  };
}
