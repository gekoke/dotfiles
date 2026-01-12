{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
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
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
        "github.com" = {
          identitiesOnly = true;
        };
        "neonproxy" = {
          user = "root";
          proxyCommand =
            let
              proxytunnel = inputs.proxytunnel.packages.${pkgs.stdenv.hostPlatform.system}.default;
            in
            "${proxytunnel}/bin/proxytunnel -z -E -p neon.grigorjan.net:443 -d 127.0.0.1:22";
        };
      };
    };
  };
}
