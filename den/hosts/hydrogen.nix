{ den, ... }:
{
  den.hosts.x86_64-linux.hydrogen.users.geko = { };

  den.aspects.hydrogen = {
    includes = [
      den.aspects.workstation
      den.aspects.work
      den.aspects.wsl
    ];

    nixos = {
      system.stateVersion = "25.11";
      nix.settings.trusted-users = [ "geko" ];
      time.timeZone = "Europe/Tallinn";
    };

    provides.geko = {
      includes = [
        den.batteries.primary-user
        den.aspects.emacs
      ];
      homeManager.home.stateVersion = "25.11";
    };
  };
}
