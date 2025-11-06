{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.linkace;
in
{
  options.services.linkace = {
    enable = lib.mkEnableOption "Linkace";

    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to an environment file for the Linkace container";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Host port to expose Linkace on";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "docker";
      containers.linkace =
        let
          image = pkgs.dockerTools.pullImage {
            imageName = "linkace/linkace";
            finalImageName = "pullimage/linkace/linkace";
            imageDigest = "sha256:cea6545a8fc24b9de1a8bbf4ef95bc617ea44b3179e99f7f2615a599de6a83f0";
            sha256 = "sha256-NWOtH1QikzFsNyWUxaI0s4CVHr8fS5HeuC+CuzLhYNw=";
          };
        in
        {
          image = "pullimage/linkace/linkace";
          imageFile = image;

          environmentFiles = [ cfg.environmentFile ];

          environment = {
            PORT = builtins.toString cfg.port;
            DB_CONNECTION = "pgsql";
            DB_HOST = "127.0.0.1";
            DB_PORT = builtins.toString config.services.postgresql.settings.port;
            DB_DATABASE = "linkace";
            DB_USERNAME = "linkace";
          };

          extraOptions = [ "--network=host" ];
        };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "linkace" ];
      ensureUsers = [
        {
          name = "linkace";
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
      authentication = ''
        host linkace linkace samehost trust
      '';
      settings.listen_addresses = lib.mkForce "localhost";
    };
  };
}
