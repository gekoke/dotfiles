{ modulesPath, config, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
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
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      virtualHosts =
        let
          https = {
            enableACME = true;
            forceSSL = true;
          };
        in
        {
          "neon.grigorjan.net" = https // {
            basicAuthFile = config.age.secrets."nginx.htpasswd".path;
            locations."/" = {
              extraConfig = ''
                add_header Content-Type text/plain;
                return 200 'Hello!';
              '';
            };
          };
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
