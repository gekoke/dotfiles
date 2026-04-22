{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.opengist;
in
{
  options.services.opengist = {
    enable = lib.mkEnableOption "OpenGist";

    externalUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      description = ''
        Public URL at which OpenGist is reachable. Used by OpenGist when
        generating absolute links (e.g. in emails, git clone URLs, OAuth
        redirects).
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/opengist";
      description = ''
        Host directory holding OpenGist's SQLite database and git
        repositories. Mounted into the container at `/opengist`.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 6157;
      description = "Host port to expose OpenGist HTTP on.";
    };

    sshPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = "Optional host port for OpenGist's git-over-SSH server.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 root root - -"
    ];

    virtualisation.oci-containers = {
      backend = "docker";
      containers.opengist =
        let
          image = pkgs.dockerTools.pullImage {
            imageName = "thomiceli/opengist";
            finalImageName = "pullimage/thomiceli/opengist";
            imageDigest = "sha256:85361da4c2f259df6e0675c54574c991ae2601922cb56c4d0419fd3e15ceb139";
            sha256 = "sha256-ntrWhMrQ4/tr7Xyw5QmySw1hwH31dt05RQnvmETVugo=";
          };
          httpPort = 6157;
          sshPort = 2222;
        in
        {
          image = "pullimage/thomiceli/opengist";
          imageFile = image;

          environment = lib.optionalAttrs (cfg.externalUrl != null) {
            OG_EXTERNAL_URL = cfg.externalUrl;
          };

          volumes = [
            "${cfg.dataDir}:/opengist"
          ];

          ports = [
            "${toString cfg.port}:${toString httpPort}"
          ]
          ++ lib.optional (cfg.sshPort != null) "${toString cfg.sshPort}:${toString sshPort}";
        };
    };
  };
}
