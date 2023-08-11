{ config, lib, ... }:

with lib;
let cfg = config.plusultra.programs.ssh;
in
{
  options.plusultra.programs.ssh = {
    enable = mkEnableOption "ssh client configuration";
  };

  config = mkIf cfg.enable {
    age.secrets.privateSshConfig = {
      file = ./private-ssh-config.age;
      owner = config.plusultra.user.name;
      mode = "700";
    };

    plusultra.home.services.ssh-agent = enabled;
    plusultra.home.programs.ssh = {
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
