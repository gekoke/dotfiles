{ config, ... }:
{
  # FIXME: make this a proper module
  config = {
    age.identityPaths =
      let
        home = config.users.users.${config.plusultra.user.name}.home;
      in
        [ "${home}/.ssh/id_ed25519" ];
  };
}
