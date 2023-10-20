{ config, lib, ... }:

with lib;
with lib.elementary;
let cfg = config.elementary.programs.ssh;
in
{
  options.elementary.programs.ssh = {
    enable = mkEnableOption "ssh client configuration";
  };

  config = mkIf cfg.enable {
    age.secrets.privateSshConfig = lib.mkIf config.elementary.secrets.enable {
      file = ./private-ssh-config.age;
      owner = config.elementary.user.name;
      mode = "700";
    };

    elementary.home.services.ssh-agent = enabled;
    elementary.home.programs.ssh = {
      enable = true;
      includes = lib.mkIf config.elementary.secrets.enable [ config.age.secrets.privateSshConfig.path ];
      extraConfig = ''
        Host *
          AddKeysToAgent yes
        Host github.com
          IdentitiesOnly yes
      '';
    };
  };
}
