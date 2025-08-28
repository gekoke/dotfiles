{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.elementary.programs.git;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.elementary.programs.git = {
    enable = mkEnableOption "git version control";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.git-absorb ];
    programs.git = {
      enable = true;
      signing = {
        signByDefault = true;
      };
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
