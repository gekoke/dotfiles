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

    age.secrets.atuinKey = lib.mkIf config.elementary.secrets.enable {
      file = ./key.age;
      owner = config.elementary.user.name;
      path = "${config.users.users.${config.elementary.user.name}.home}/.local/share/atuin/key";
      mode = "700";
    };
  };
}
