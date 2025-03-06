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

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZjHdiGT2JDe/3tdEt5hNsOw6bOo0DEfGTkD4+7/ASs geko@carbon"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnuNZ0JfFZ4sHUgatHZ+hE0qA+U7XX6m7ztTfmIrIgQ nixos@nixos"
  ];

  system.stateVersion = "25.05";
}
