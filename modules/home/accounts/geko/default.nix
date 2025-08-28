{
  config,
  lib,
  ...
}:
let
  cfg = config.elementary.accounts.geko;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.elementary.accounts.geko = {
    enable = mkEnableOption "the geko account user details";
  };

  config = mkIf cfg.enable {
    programs.git = {
      userName = "Gregor Grigorjan";
      userEmail = "gregor@grigorjan.net";
      extraConfig.github.user = "gekoke";
    };
  };
}
