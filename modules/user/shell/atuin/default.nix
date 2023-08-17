{ config, lib, ... }:
with lib;
let cfg = config.plusultra.user.shell.atuin;
in
{
  options.plusultra.user.shell.atuin = {
    enable = mkEnableOption "Atuin";
  };

  config = mkIf cfg.enable {
    plusultra.home.programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        inline_height = 30;
        style = "compact";
      };
    };

    age.secrets.atuinKey = {
      file = ./key.age;
      owner = config.plusultra.user.name;
      path = "${config.users.users.${config.plusultra.user.name}.home}/.local/share/atuin/key";
      mode = "700";
    };
  };
}
