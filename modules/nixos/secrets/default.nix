{ config, lib, ... }:
with lib;
with lib.elementary;
let
  cfg = config.elementary.secrets;
in
{
  options.elementary.secrets = {
    enable = mkEnableOption "secrets management with agenix";
  };

  config = mkIf cfg.enable {
    age.identityPaths =
      let
        inherit (config.users.users.${config.elementary.user.name}) home;
      in
      [ "${home}/.ssh/id_ed25519" ];
  };
}
