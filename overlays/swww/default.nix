{ channels, ... }:

final: prev:
{
  # FIXME: can go back to unstable when https://github.com/Horus645/swww/issues/144
  # is fixed
  inherit (channels.nixpkgs-stable) swww;
}
