{ modulesPath, ... }:
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

  services = {
    openssh.enable = true;
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      virtualHosts."neon.grigorjan.net" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          location / {
              add_header Content-Type text/plain;
              return 200 'Hello!';
          }
        '';
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
