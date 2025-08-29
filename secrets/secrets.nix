let
  publicKey = import ../public-key.nix;
in
{
  "authinfo.age".publicKeys = publicKey.ofAll.workstations;
  "neon-nginx.htpasswd.age".publicKeys = publicKey.ofAll.hosts;
}
