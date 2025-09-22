let
  publicKey = import ../public-key.nix;
  rules = {
    "authinfo.age".publicKeys = publicKey.ofAll.workstations;
    "neon-nginx.htpasswd.age".publicKeys = publicKey.ofAll.hosts;

    # Deploy secrets
    "aws-secret-key.age".publicKeys = publicKey.ofAll.hosts ++ [ publicKey.for.githubActions ];
    "cachix-auth-token.age".publicKeys = publicKey.ofAll.hosts ++ [ publicKey.for.githubActions ];
    "cloudflare-api-token.age".publicKeys = publicKey.ofAll.hosts ++ [ publicKey.for.githubActions ];
    "hcloud-token.age".publicKeys = publicKey.ofAll.hosts ++ [ publicKey.for.githubActions ];
    "neon-api-key.age".publicKeys = publicKey.ofAll.hosts ++ [ publicKey.for.githubActions ];
  };
in
builtins.mapAttrs (_: rule: rule // { armor = true; }) rules
