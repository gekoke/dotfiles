{
  self,
  config,
  lib,
  ...
}:
let
  cfg = config.identities.geko;
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [
    self.homeModules."roles.work"
  ];

  options.identities.geko = {
    enable = mkEnableOption "the Geko account identity";
  };

  config = mkIf cfg.enable {
    roles.work.email = "gregor.grigorjan@gamesglobal.com";

    programs.git = {
      settings = {
        user = {
          name = "Gregor Grigorjan";
          email = "gregor@grigorjan.net";
        };
        github.user = "gekoke";
      };
    };
  };
}
