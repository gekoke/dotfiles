{ config, lib, ... }:
with lib;
let cfg = config.plusultra.user.accounts;
in
{
  options.plusultra.user.accounts = with types; {
    enable = mkEnableOption "user accounts configuration";
    fullName = mkOpt str "Gregor Grigorjan" "The full name of the associated person";
    primaryEmailAddress = mkOpt str "gregor@grigorjan.net" "The primary email address of the associated person";
  };

  config = mkIf cfg.enable {
    plusultra.home.extraOptions.accounts.email.accounts = {
      ${cfg.fullName} = {
        primary = true;
        address = cfg.primaryEmailAddress;
      };
    };
  };
}
