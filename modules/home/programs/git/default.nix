{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.git.elementary.config;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.programs.git.elementary.config = {
    enable = mkEnableOption "Elementary git configuration";
  };

  config = mkIf cfg.enable {
    programs.git = {
      signing.signByDefault = true;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        rerere.enabled = true;
        diff = {
          colorMoved = true;
          algorithm = "histogram";
        };
        credential.helper = "store";
        gc.auto = 0;
      };
    };
  };
}
