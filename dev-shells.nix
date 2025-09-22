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
            inputs'.agenix.packages.agenix
            pkgs.deadnix
            pkgs.opentofu
            pkgs.tflint
          ];

          shellHook = config.pre-commit.installationScript;
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
