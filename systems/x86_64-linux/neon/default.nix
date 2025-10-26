{
  config,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
  };

  nix.settings.experimental-features = "nix-command flakes";

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
          "linkace.grigorjan.net" = https // {
            locations."/".proxyPass = "http://127.0.0.1:${builtins.toString config.services.linkace.port}";
          };
        };
      in
      {
        enable = true;
        recommendedTlsSettings = true;
        recommendedProxySettings = true;
        inherit virtualHosts;
      };
    linkace = {
      enable = true;
      environmentFile = config.age.secrets."linkace.env".path;
    };
  };

  age.secrets."linkace.env".file = ./../../../secrets/linkace.env.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@grigorjan.net";
  };

  users.users.root.openssh.authorizedKeys.keys =
    let
      publicKey = import ../../../public-key.nix;
    in
    publicKey.ofAll.hosts ++ [ publicKey.for.githubActions ];

  system.stateVersion = "25.05";
}
