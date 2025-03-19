{
  modulesPath,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.glucose.nixosModules.default
    ./disk-config.nix
  ];

  nix.gc.automatic = true;

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  age.secrets."nginx.htpasswd" = {
    file = ../../../secrets/neon-nginx.htpasswd.age;
    mode = "0770";
    owner = "nginx";
    group = "nginx";
  };

  services = {
    openssh.enable = true;
    glucose = {
      enable = true;
      environmentFile = "/run/glucose/.env";
    };
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      virtualHosts =
        let
          https = {
            enableACME = true;
            forceSSL = true;
          };
          basicAuth = {
            basicAuthFile = config.age.secrets."nginx.htpasswd".path;
          };
        in
        {
          "neon.grigorjan.net" =
            https
            // basicAuth
            // {
              locations."/".root = pkgs.writeTextDir "index.html" ''
                <p>Hello!</p>
              '';
            };
          "api.glucose.grigorjan.net" = lib.mkIf config.services.glucose.enable (
            https
            // basicAuth
            // {
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString config.services.glucose.port}";
                extraConfig = "proxy_pass_header Authorization;";
              };
            }
          );
        };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@grigorjan.net";
  };

  users.users.root.openssh.authorizedKeys.keys =
    let
      inherit (import ../../../keys.nix) keys groups;
    in
    groups.hosts ++ [ keys.githubActions ];

  system.stateVersion = "25.05";
}
