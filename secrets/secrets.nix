let
  publicKeys = import ../public-keys.nix;
  rules = {
    "authinfo.age".publicKeys = publicKeys.geko;
    "linkace.env.age".publicKeys = publicKeys.geko ++ publicKeys.vps;
    # Deploy secrets
    "aws-secret-key.age".publicKeys = publicKeys.geko ++ publicKeys.githubActions;
    "cachix-auth-token.age".publicKeys = publicKeys.geko ++ publicKeys.githubActions;
    "cloudflare-api-token.age".publicKeys = publicKeys.geko ++ publicKeys.githubActions;
    "github-token.age".publicKeys = publicKeys.geko ++ publicKeys.githubActions;
    "neon-api-key.age".publicKeys = publicKeys.geko ++ publicKeys.githubActions;
  };
in
builtins.mapAttrs (_: rule: rule // { armor = true; }) rules
