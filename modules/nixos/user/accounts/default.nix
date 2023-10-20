{ config, lib, ... }:
with lib;
with lib.elementary;
let cfg = config.elementary.user.accounts;
in
{
  options.elementary.user.accounts = with types; {
    enable = mkEnableOption "user accounts configuration";
    fullName = mkOpt (nullOr str) "Gregor Grigorjan" "The full name of the associated person";
    primaryEmailAddress = mkOpt (nullOr str) "gregor@grigorjan.net" "The primary email address of the associated person";
  };

  config = mkIf cfg.enable {
    elementary.home.extraOptions.accounts.email.accounts = {
      ${cfg.fullName} = {
        primary = true;
        address = cfg.primaryEmailAddress;
      };
    };
  };
}
