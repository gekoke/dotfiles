{ config, lib, ... }:
with lib;
with lib.elementary;
let
  cfg = config.elementary.user;
in
{
  options.elementary.user = with types; {
    enable = mkEnableOption "default user";
    name = mkOpt str "geko" "The name to use for the user account";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned to";
  };

  config = mkIf cfg.enable {
    elementary.user.shell = {
      base = enabled;
      zsh = enabled;
      atuin = enabled;
    };

    elementary.home.extraOptions.xdg.userDirs = enabled // {
      createDirectories = true;
    };

    users.users.${cfg.name} = {
      inherit (cfg) name;
      isNormalUser = true;
      initialPassword = "password";
      createHome = true;
      group = "users";
      extraGroups = [ "wheel" ] ++ cfg.extraGroups;
    };
  };
}
