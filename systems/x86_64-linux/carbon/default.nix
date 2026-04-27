{
  config,
  inputs,
  pkgs,
  self,
  ...
}:
{
  imports =
    builtins.attrValues {
      inherit (inputs.nixos-hardware.nixosModules)
        common-pc
        common-pc-ssd
        common-cpu-intel
        common-gpu-nvidia-nonprime
        ;
    }
    ++ [
      self.nixosModules."roles.graphical"
      self.nixosModules."roles.workstation"
      ./hardware-configuration.nix
    ];

  roles = {
    graphical.enable = true;
    workstation.enable = true;
  };

  elementary.programs.emacs.package = pkgs.emacs30-pgtk;

  hardware = {
    graphics.enable = true;
    nvidia = {
      # Modesetting is required
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
    };
  };

  home-manager = {
    sharedModules = [
      self.homeModules."identities.geko"
      { xdg.userDirs.setSessionVariables = false; }
    ];

    users.${config.constants.default.user.name} = {
      programs.git.signing.key = "1E9AFDF3275F99EE";
      identities.geko.enable = true;
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

  system.stateVersion = "25.05";
}
