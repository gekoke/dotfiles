{
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

  elementary = {
    hardware.nvidia.enable = true;
    programs.emacs.package = pkgs.emacs30-pgtk;
  };

  home-manager.users.geko.programs.git.signing.key = "1E9AFDF3275F99EE";

  boot.loader.grub.gfxmodeEfi = "1920x1080";

  networking.firewall.allowedTCPPorts = [
    8000
    8080
  ];

  system.stateVersion = "25.05";
}
