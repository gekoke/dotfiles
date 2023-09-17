{ config, lib, ... }:
with lib;
let cfg = config.elementary.security.sudo;
in
{
  options.elementary.secrets = {
    enable = mkEnableOption "secrets management with agenix";
  };

  config = mkIf cfg.enable {
    age.identityPaths =
      let
        home = config.users.users.${config.elementary.user.name}.home;
      in
      [ "${home}/.ssh/id_ed25519" ];
  };
}
