let
  inherit (import ../keys.nix) groups;
in
{
  "authinfo.age".publicKeys = groups.hosts;
  "neon-nginx.htpasswd.age".publicKeys = groups.hosts;
}
