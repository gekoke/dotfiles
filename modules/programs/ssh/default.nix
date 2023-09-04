{ config, lib, ... }:

with lib;
let cfg = config.elementary.programs.ssh;
in
{
  options.elementary.programs.ssh = {
    enable = mkEnableOption "ssh client configuration";
  };

  config = mkIf cfg.enable {
    age.secrets.privateSshConfig = {
      file = ./private-ssh-config.age;
      owner = config.elementary.user.name;
      mode = "700";
    };

    elementary.home.services.ssh-agent = enabled;
    elementary.home.programs.ssh = {
      enable = true;
      includes = [ config.age.secrets.privateSshConfig.path ];
      extraConfig = ''
        Host *
          AddKeysToAgent yes
        Host github.com
          IdentitiesOnly yes
      '';
    };
  };
}
