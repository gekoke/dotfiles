{ config, lib, ... }:
with lib;
let cfg = config.plusultra.user;
in
{
  options.plusultra.user = with types; {
    enabled = mkEnableOption "default user";
    name = mkOpt str "geko" "The name to use for the user account";
    fullName = mkOpt str "Gregor Grigorjan" "The full name of the associated person";
    primaryEmailAddress = mkOpt str "gregor@grigorjan.net" "The primary email address of the associated person";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned";
  };

  config = {
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
