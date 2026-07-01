{ inputs, den, ... }:
{
  den.hosts.x86_64-linux.neon = { };

  den.aspects.neon = {
    includes = [
      den.aspects.linkace
      den.aspects.opengist
    ];

    nixos =
      {
        config,
        pkgs,
        modulesPath,
        ...
      }:
      {
        imports = [
          inputs.agenix.nixosModules.default
          (modulesPath + "/installer/scan/not-detected.nix")
          (modulesPath + "/profiles/qemu-guest.nix")
          inputs.disko.nixosModules.disko
          ./_neon-disk-config.nix
          inputs.abiopetaja.nixosModules.default
        ];

        system.stateVersion = "25.05";

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

          postgresqlBackup = {
            enable = true;
            compression = "none";
          };

          linkace = {
            enable = true;
            environmentFile = config.age.secrets."linkace.env".path;
            database.scramSha256PasswordHash = "SCRAM-SHA-256$4096:7sUwTWqRn4M0oJX/zN9Y4w==$febSzasL8KtqmAYwoDdt09cQUVs6k6+xqph+5EQD0mk=:4eWX3Qsw4Foiq7Z6sJpPSCS0Xax363cZom4WdmhizFE=";
          };
          opengist = {
            enable = true;
            externalUrl = "https://opengist.grigorjan.net";
          };
          abiopetaja = {
            enable = true;
            domains = [ "abiopetaja.grigorjan.net" ];
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
              in
              {
                "siege.grigorjan.net" = https // {
                  globalRedirect = "docs.google.com/document/d/18rH8YFU7kuXRncqRFWnMZK3eEMBk6Vpz2nYOL5u_WZY";
                  redirectCode = 302;
                };
                "linkace.grigorjan.net" = https // {
                  locations."/".proxyPass = "http://127.0.0.1:${toString config.services.linkace.port}";
                };
                "opengist.grigorjan.net" = https // {
                  locations."/".proxyPass = "http://127.0.0.1:${toString config.services.opengist.port}";
                };
                "www.grigorjan.net" = https // {
                  serverAliases = [ "grigorjan.net" ];
                  root = "${inputs.website.packages.${pkgs.stdenv.hostPlatform.system}.default}/public";
                  extraConfig = ''
                    error_page 404 /404.html;
                  '';
                };
              };
          };
        };

        age.secrets."linkace.env".file = ../../secrets/linkace.env.age;
        age.secrets."cloudflare-acme.env".file = ../../secrets/cloudflare-acme.env.age;

        security.acme = {
          acceptTerms = true;
          defaults = {
            email = "acme@grigorjan.net";
            dnsProvider = "cloudflare";
            environmentFile = config.age.secrets."cloudflare-acme.env".path;
          };
        };

        users.users.root.openssh.authorizedKeys.keys =
          let
            publicKeys = import ../../public-keys.nix;
          in
          publicKeys.geko ++ publicKeys.githubActions;
      };
  };
}
