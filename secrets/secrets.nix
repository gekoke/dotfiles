let
  inherit (import ../keys.nix) groups;
in
{
  "authinfo.age".publicKeys = groups.hosts;
}
