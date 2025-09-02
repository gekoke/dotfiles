let
  publicKey = import ../public-key.nix;
  rules = {
    "authinfo.age".publicKeys = publicKey.ofAll.workstations;
    "neon-nginx.htpasswd.age".publicKeys = publicKey.ofAll.hosts;
  };
in
builtins.mapAttrs (_: rule: rule // { armor = true; }) rules
