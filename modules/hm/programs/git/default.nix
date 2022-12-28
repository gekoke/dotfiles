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
    programs = {
      git = {
        enable = true;

        signing = {
          signByDefault = false;
          key = "B4BE4DE6F6F29B82";
        };

        extraConfig = {
          init.defaultBranch = "main";
          credential.helper = "store";
          push.autoSetupRemote = true;
        };
      };
    };
  };
}
