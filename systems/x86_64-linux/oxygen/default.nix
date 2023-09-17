{ lib, inputs, pkgs, ... }:

with lib;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    common-pc
    common-pc-ssd
    common-cpu-intel
    common-gpu-nvidia-nonprime
  ];

  elementary = {
    hardware.nvidia = enabled;
    roles.workstation = enabled;
    user = {
      name = "gato";
      accounts = {
        fullName = "";
        primaryEmailAddress = null;
      };
    };
    programs.git = {
      userName = "Mari0nM";
      userEmail = "?";
      signingKey = null;
      signByDefault = false;
      githubUsername = "Mari0nM";
    };
  };

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

  system.stateVersion = "23.11";
}
