{
  modulesPath,
  config,
  pkgs,
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
          httpsConfig = {
            enableACME = true;
            forceSSL = true;
          };
          withHTTPS = virtualHosts: builtins.mapAttrs (_: config: config // httpsConfig) virtualHosts;
        in
        withHTTPS {
          "neon.grigorjan.net" = {
            basicAuthFile = config.age.secrets."nginx.htpasswd".path;
            locations."/".root = pkgs.writeTextDir "index.html" ''
              <p>Hello!</p>
            '';
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
