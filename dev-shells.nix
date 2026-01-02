{ inputs, ... }:
{
  perSystem =
    {
      config,
      inputs',
      pkgs,
      lib,
      system,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          packages = [
            # keep-sorted start
            inputs'.agenix.packages.agenix
            pkgs.deadnix
            pkgs.omnix
            pkgs.opentofu
            pkgs.pinact
            pkgs.prettier
            pkgs.tflint
            # keep-sorted end
          ];

          shellHook = config.pre-commit.installationScript;
        };

        cache = pkgs.mkShellNoCC {
          installationScript = inputs.agenix-shell.lib.installationScript system {
            secrets.CACHIX_AUTH_TOKEN.file = ./secrets/cachix-auth-token.age;
          };
        };

        deploy = pkgs.mkShellNoCC {
          env =
            let
              awsAccessKeyId = "AKIA2GKH7CBDHA4OSHRD"; # gitleaks:allow
            in
            {
              TF_VAR_aws_access_key = awsAccessKeyId;
              AWS_ACCESS_KEY_ID = awsAccessKeyId; # Automatically source for backend config (`tofu init`)
            };
          shellHook =
            let
              installationScript = inputs.agenix-shell.lib.installationScript system {
                secrets = {
                  AWS_SECRET_ACCESS_KEY.file = ./secrets/aws-secret-key.age; # Automatically source for backend config (`tofu init`)

                  TF_VAR_aws_secret_key.file = ./secrets/aws-secret-key.age;
                  TF_VAR_cloudflare_api_token.file = ./secrets/cloudflare-api-token.age;
                  TF_VAR_github_token.file = ./secrets/github-token.age;
                  TF_VAR_hcloud_token.file = ./secrets/hcloud-token.age;
                  TF_VAR_neon_api_key.file = ./secrets/neon-api-key.age;
                };
              };
            in
            ''
              source ${lib.getExe installationScript}
            '';
          packages =
            let
              pkgs = inputs'.nixpkgs-for-opentofu.legacyPackages;
              openTofuWithPlugins = pkgs.opentofu.withPlugins (p: [
                p.aws
                p.cloudflare
                p.github
                p.hcloud
                p.neon
                p.tls

                # nixos-anwyhere dependencies
                p.external
                p.null
              ]);
            in
            [ openTofuWithPlugins ];
        };
      };
    };
}
