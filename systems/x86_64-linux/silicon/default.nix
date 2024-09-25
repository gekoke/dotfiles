{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.elementary) enabled;
in
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "24.11";

  wsl = {
    enable = true;
    defaultUser = "geko";
    wslConf = {
      user.default = "geko";
      network.hostname = "silicon";
    };
  };

  home-manager.users.geko = {
    home.packages = [
      pkgs.nodePackages."@angular/cli"
      pkgs.python311
      pkgs.gnumake
      pkgs.gcc
      pkgs.powershell
      (pkgs.dotnetCorePackages.combinePackages [
        pkgs.dotnet-sdk_6
        pkgs.dotnet-sdk_8
      ])
      pkgs.azure-cli
      pkgs.turbo
    ];

    services.gpg-agent.extraConfig = ''
      pinentry-program "/mnt/c/Program Files (x86)/GnuPG/bin/pinentry-basic.exe"
    '';
  };

  networking.firewall.allowedTCPPorts = [
    1499
  ];

  time.timeZone = "Europe/Tallinn";

  elementary = {
    virtualisation.docker.enable = true;
    nix = enabled;
    user = enabled // {
      accounts = enabled;
    };
    secrets = enabled;
    suites = {
      cli-utils = enabled;
    };
    security = {
      sudo = enabled;
      gpg = enabled;
    };
    programs = {
      git = enabled // {
        userEmail = "gregor.grigorjan@gamesglobal.com";
        signingKey = "FB5F09CB29F94BC5";
      };
      ssh = enabled;
      emacs = enabled // {
        package = pkgs.emacs29;
      };
      direnv = enabled;
    };
  };
}
