{ config, lib, ... }:
with lib;
let cfg = config.plusultra.user.accounts;
in
{
  options.plusultra.user.accounts = with types; {
    enabled = mkOpt bool true "whether to enable user accounts configuration";
  };

  config = mkIf cfg.enabled {
    plusultra.home.extraOptions.accounts.email.accounts = {
      ${config.plusultra.user.fullName} = {
        primary = true;
        address = config.plusultra.user.primaryEmailAddress;
      };
    };
  };
}
