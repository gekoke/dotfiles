{ channels, ... }:

final: prev:
{
  inherit (channels.unstable) base16-schemes;
}
