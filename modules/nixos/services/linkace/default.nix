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
          linkacePort = 3000;
        in
        {
          image = "pullimage/linkace/linkace";
          imageFile = image;

          environmentFiles = [ cfg.environmentFile ];

          environment = {
            PORT = toString linkacePort;
            DB_CONNECTION = "pgsql";
            DB_HOST = "/run/postgresql";
            DB_DATABASE = "linkace";
            DB_USERNAME = "linkace";
          };

          volumes = [
            "/run/postgresql:/run/postgresql"
          ];

          ports = [
            "${toString cfg.port}:${toString linkacePort}"
          ];
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
        local  linkace  linkace  scram-sha-256
      '';
    };
  };
}
