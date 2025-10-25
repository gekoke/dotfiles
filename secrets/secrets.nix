let
  publicKey = import ../public-key.nix;
  rules = {
    "authinfo.age".publicKeys = publicKey.ofAll.workstations;
    "linkace.env.age".publicKeys = publicKey.ofAll.hosts;

    # Deploy secrets
    "aws-secret-key.age".publicKeys = publicKey.ofAll.workstations ++ [ publicKey.for.githubActions ];
    "cachix-auth-token.age".publicKeys = publicKey.ofAll.workstations ++ [
      publicKey.for.githubActions
    ];
    "cloudflare-api-token.age".publicKeys = publicKey.ofAll.workstations ++ [
      publicKey.for.githubActions
    ];
    "github-token.age".publicKeys = publicKey.ofAll.workstations ++ [
      publicKey.for.githubActions
    ];
    "neon-api-key.age".publicKeys = publicKey.ofAll.workstations ++ [ publicKey.for.githubActions ];
  };
in
builtins.mapAttrs (_: rule: rule // { armor = true; }) rules
