{
  modulesPath,
  ...
}:
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
    nginx =
      let
        https = {
          enableACME = true;
          forceSSL = true;
        };
        virtualHosts = {
          "siege.grigorjan.net" = https // {
            globalRedirect = "docs.google.com/document/d/18rH8YFU7kuXRncqRFWnMZK3eEMBk6Vpz2nYOL5u_WZY";
            redirectCode = 302;
          };
        };
      in
      {
        enable = true;
        recommendedTlsSettings = true;
        recommendedProxySettings = true;
        inherit virtualHosts;
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
