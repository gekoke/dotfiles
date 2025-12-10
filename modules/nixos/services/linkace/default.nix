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
            imageDigest = "sha256:4cd65ce9d9d57976b6ef4414747388833d0f8d02860287da4aa6bea2e0fffc1f";
            sha256 = "sha256-4XetV/qbP2QaduU+p7JwBKMdeUTt5hcpUFTtQu+P9aU=";
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
        }
      ];
      authentication = ''
        host linkace linkace samehost trust
      '';
    };
  };
}
