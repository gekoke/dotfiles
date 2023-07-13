{ config, lib, ... }:

with lib;
let
  cfg = config.plusultra.security.gpg;
in
{
  options.plusultra.security.gpg = with types; {
    enable = mkEnableOption "gnupg";
  };

  config = mkIf cfg.enable {
    services.pcscd.enable = true; # Card readers n stuff

    plusultra.home = {
      programs.gpg = enabled;
      services.gpg-agent = enabled;
    };
  };
}
