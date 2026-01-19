{
  config,
  lib,
  inputs,
  self,
  ...
}:
with lib;
with lib.elementary;
let
  cfg = config.elementary.user;
in
{
  imports = [
    inputs.noshell.nixosModules.default
    self.nixosModules."constants"
  ];

  options.elementary.user = with types; {
    enable = mkEnableOption "default user";
    name = mkOpt str config.constants.default.user.name "The name to use for the user account";
  };

  config = mkIf cfg.enable {
    programs.noshell.enable = true;

    users.users.${cfg.name} = {
      inherit (cfg) name;
      isNormalUser = true;
      initialPassword = "password";
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
