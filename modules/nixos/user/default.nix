{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.elementary;
let
  cfg = config.elementary.user;
in
{
  imports = [ inputs.noshell.nixosModules.default ];

  options.elementary.user = with types; {
    enable = mkEnableOption "default user";
    name = mkOpt str "geko" "The name to use for the user account";
  };

  config = mkIf cfg.enable {
    programs.noshell.enable = true;
    elementary = {
      home.extraOptions.xdg.userDirs = enabled // {
        createDirectories = true;
      };
    };

    users.users.${cfg.name} = {
      inherit (cfg) name;
      isNormalUser = true;
      initialPassword = "password";
      createHome = true;
      group = "users";
      extraGroups = lib.intersectLists (lib.attrNames config.users.groups) [
        # keep-sorted start
        "docker"
        "networkmanager"
        "wheel"
        # keep-sorted end
      ];
    };
  };
}
