{ config, lib, ... }:

with lib;
with lib.elementary;
let
  cfg = config.elementary.programs.ssh;
in
{
  options.elementary.programs.ssh = {
    enable = mkEnableOption "ssh client configuration";
  };

  config = mkIf cfg.enable {
    elementary.home.services.ssh-agent = enabled;
    elementary.home.programs.ssh = {
      enable = true;
      extraConfig = ''
        Host *
          AddKeysToAgent yes
        Host github.com
          IdentitiesOnly yes
      '';
    };
  };
}
