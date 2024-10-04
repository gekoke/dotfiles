{ config, lib, ... }:
with lib;
with lib.elementary;
let
  cfg = config.elementary.user.shell.atuin;
in
{
  options.elementary.user.shell.atuin = {
    enable = mkEnableOption "Atuin";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        inline_height = 30;
        style = "compact";
      };
    };
  };
}
