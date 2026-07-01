{ inputs, den, ... }:
{
  den.hosts.x86_64-linux.carbon.users.geko.emacs =
    inputs.self.packages.x86_64-linux.elementary-emacs-pgtk;

  den.aspects.carbon = {
    includes = [
      den.aspects.workstation
      den.aspects.graphical
      (den.batteries.unfree [
        "nvidia-kernel-modules"
        "nvidia-settings"
        "nvidia-x11"
      ])
    ];

    nixos =
      { config, ... }:
      {
        imports = [
          ./_carbon-hardware.nix
        ]
        ++ builtins.attrValues {
          inherit (inputs.nixos-hardware.nixosModules)
            common-pc
            common-pc-ssd
            common-cpu-intel
            common-gpu-nvidia-nonprime
            ;
        };

        system.stateVersion = "25.05";
        nix.settings.trusted-users = [ "geko" ];

        hardware = {
          graphics.enable = true;
          nvidia = {
            # GTX 1080
            open = false;
            package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

            modesetting.enable = true; # required
            powerManagement.enable = true;
            nvidiaSettings = true;
          };
        };

        boot = {
          loader.grub.gfxmodeEfi = "1920x1080";
          supportedFilesystems = [ "ntfs" ];
        };

        networking.firewall.allowedTCPPorts = [
          8000
          8080
        ];
      };

    provides.geko = {
      includes = [
        den.batteries.primary-user
        den.aspects.emacs
      ];

      homeManager = {
        home.stateVersion = "25.05";
        programs.firefox.configPath = ".config/mozilla/firefox";
      };
    };
  };
}
