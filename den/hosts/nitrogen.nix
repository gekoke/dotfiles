{ den, ... }:
{
  den.hosts.x86_64-linux.nitrogen.users.lev.emacsVariant = "elementary-emacs";

  den.aspects.nitrogen = {
    includes = [
      den.aspects.workstation
      den.aspects.work
      den.aspects.wsl
    ];

    nixos = {
      system.stateVersion = "25.11";
      time.timeZone = "Europe/Tallinn";

      # HACK: manually create the linger marker so `systemctl --user` works
      # over the WSL socket. Upstream tracking:
      # https://github.com/nix-community/NixOS-WSL/issues/375#issuecomment-2411845271
      systemd.tmpfiles.rules = [ "f /var/lib/systemd/linger/lev" ];
    };

    provides.lev = {
      includes = [
        den.batteries.primary-user
        den.aspects.emacs
      ];
      homeManager.home.stateVersion = "25.11";
    };
  };
}
