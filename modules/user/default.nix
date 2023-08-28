{ config, lib, ... }:
with lib;
let cfg = config.plusultra.user;
in
{
  options.plusultra.user = with types; {
    enable = mkEnableOption "default user";
    name = mkOpt str "geko" "The name to use for the user account";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned to";
  };

  config = mkIf cfg.enable {
    plusultra.user.shell = {
      base = enabled;
      zsh = enabled;
      atuin = enabled;
    };

    plusultra.home.extraOptions.xdg.userDirs = enabled // { createDirectories = true; };

    users.users.${cfg.name} = {
      inherit (cfg) name;
      uid = 1000;
      isNormalUser = true;
      initialPassword = "password";
      home = "/home/${cfg.name}";
      group = "users";
      extraGroups = [ "wheel" ] ++ cfg.extraGroups;
    };
  };
}
