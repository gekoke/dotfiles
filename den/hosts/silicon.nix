{ inputs, den, ... }:
{
  den.hosts.x86_64-linux.silicon.users.geko.emacs =
    inputs.self.packages.x86_64-linux.elementary-emacs-pgtk;

  den.aspects.silicon = {
    includes = [
      den.aspects.workstation
      den.aspects.work
      den.aspects.wsl
    ];

    nixos = {
      system.stateVersion = "24.11";
      nix.settings.trusted-users = [ "geko" ];
      time.timeZone = "Europe/Tallinn";

      # With the userland proxy enabled, Windows cannot reach published container ports on localhost under mirrored networking.
      # With it disabled, Docker routes that traffic through iptables rules instead, and Windows can reach the ports.
      virtualisation.docker.daemon.settings.userland-proxy = false;
    };

    provides.geko = {
      includes = [
        den.batteries.primary-user
        den.aspects.emacs
      ];
      homeManager.home.stateVersion = "24.11";
    };
  };
}
