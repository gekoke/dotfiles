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
    programs = {
      git = {
        userName = "Gregor Grigorjan";
        userEmail = "gregor@grigorjan.net";
        extraConfig.github.user = "gekoke";
      };
    };
  };
}
