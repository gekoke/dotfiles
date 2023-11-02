{ lib, inputs, pkgs, ... }:

with lib;
with lib.elementary;
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
        fullName = "Marion Martin";
        primaryEmailAddress = "marion@marionmartin.net";
      };
    };
    programs.git = {
      userName = "Mari0nM";
      userEmail = "marion@marionmartin.net";
      signingKey = "FB2EB18FF2432FBB";
      signByDefault = true;
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
    with pkgs; [
      discord
      qbittorrent
      mpv

      signal-desktop
      librewolf

      vscode
      infraCourseAnsible
      ansible-lint
      ansible-language-server
    ];

  system.stateVersion = "23.11";

  hardware.bluetooth = enabled;

  programs.steam = enabled;

  services = {
    blueman = enabled;
  };
}
