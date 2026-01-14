{
  config,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    inputs.abiopetaja.nixosModules.default
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

  virtualisation.docker.autoPrune.enable = true;

  services = {
    openssh.enable = true;
    linkace = {
      enable = true;
      environmentFile = config.age.secrets."linkace.env".path;
    };
    abiopetaja = {
      enable = true;
      domains = [ "abiopetaja.grigorjan.net" ];
    };
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      additionalModules = [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.http_proxy_connect_module
      ];
      virtualHosts =
        let
          https = {
            enableACME = true;
            forceSSL = true;
          };
        in
        {
          "siege.grigorjan.net" = https // {
            globalRedirect = "docs.google.com/document/d/18rH8YFU7kuXRncqRFWnMZK3eEMBk6Vpz2nYOL5u_WZY";
            redirectCode = 302;
          };
          "linkace.grigorjan.net" = https // {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.linkace.port}";
          };
          "www.grigorjan.net" = https // {
            serverAliases = [ "grigorjan.net" ];
            root = "${inputs.website.packages.${pkgs.stdenv.hostPlatform.system}.default}/public";
            extraConfig = ''
              error_page 404 /404.html;
            '';
          };
          "neon.grigorjan.net" = https // {
            extraConfig = ''
              proxy_connect;
              proxy_connect_allow 22;
              proxy_connect_address 127.0.0.1;
            '';
          };
        };
    };
  };

  age.secrets."linkace.env".file = ./../../../secrets/linkace.env.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@grigorjan.net";
  };

  users.users.root.openssh.authorizedKeys.keys =
    let
      publicKeys = import ../../../public-keys.nix;
    in
    publicKeys.geko ++ publicKeys.githubActions;

  system.stateVersion = "25.05";
}
