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

    database = {
      scramSha256PasswordHash = lib.mkOption {
        type = lib.types.singleLineStr;
        description = "The SCRAM-SHA-256 hashed password to use for the database";
      };
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
            imageDigest = "sha256:2f562c1527eaa106fca6e5144cd7b0a52edc1634cbd0578826c31ca62057f6db"; # v2.4.2
            sha256 = "sha256-z/BXW23eNCNzTLYnafAeS6a9zEWJhkd1SyURM+PuVp4=";
          };
        in
        {
          image = "pullimage/linkace/linkace";
          imageFile = image;

          environmentFiles = [ cfg.environmentFile ];

          environment = {
            PORT = toString cfg.port;
            DB_CONNECTION = "pgsql";
            DB_HOST = "127.0.0.1";
            DB_PORT = toString config.services.postgresql.settings.port;
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
          ensureClauses = {
            login = true;
            password = cfg.database.scramSha256PasswordHash;
          };
        }
      ];
      authentication = ''
        #type database   DBuser    auth-method
        host  linkace    linkace   127.0.0.1/32 scram-sha-256
        host  linkace    linkace   ::1/128 scram-sha-256
      '';
    };
  };
}
