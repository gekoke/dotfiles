{
  config,
  lib,
  ...
}:
let
  cfg = config.identities.geko;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.identities.geko = {
    enable = mkEnableOption "the Geko account identity";
  };

  config = mkIf cfg.enable {
    programs.git = {
      settings = {
        user = {
          name = "Gregor Grigorjan";
          email = "gregor@grigorjan.net";
        };
        github.user = "gekoke";
      };

      includes = [
        {
          condition = "gitdir:~/Work/";
          contents.user.email = "gregor.grigorjan@gamesglobal.com";
        }
      ];
    };
  };
}
