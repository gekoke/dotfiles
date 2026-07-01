{ lib, ... }:
{
  den.aspects.nh.provides.to-users.homeManager =
    { config, ... }:
    {
      programs.nh = {
        enable = true;
        flake = lib.strings.normalizePath (config.home.homeDirectory + "/Repos/dotfiles");
      };
    };
}
