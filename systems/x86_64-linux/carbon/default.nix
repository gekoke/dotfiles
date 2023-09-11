{ lib, inputs, pkgs, ... }:

with lib;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    common-pc
    common-pc-ssd
    common-cpu-intel-kaby-lake
    common-gpu-nvidia-nonprime
  ];

  elementary = {
    hardware.nvidia = enabled;
    roles.workstation = enabled;
  };

  boot.loader.grub.gfxmodeEfi = "1920x1080";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8000
      8080
    ];
  };

  system.stateVersion = "23.11";

  elementary.home.packages =
    let
      infraCourseAnsible = pkgs.python3Packages.toPythonApplication
        (pkgs.python3Packages.ansible-core.overridePythonAttrs (oldAttrs: rec {
          version = "2.13.11";
          src = oldAttrs.src.override {
            inherit version;
            hash = "sha256-nqAFlNzutLVoKIUoMqvt7S6IopSgPDlZ2kmaQ+UW9oA=";
          };
        }));
    in
    [ infraCourseAnsible ];
}
