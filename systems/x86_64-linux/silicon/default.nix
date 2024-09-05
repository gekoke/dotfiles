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
    ];
  };

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
    };
    programs = {
      git = enabled // {
        signByDefault = false;
        userEmail = "gregor.grigorjan@gamesglobal.com";
      };
      ssh = enabled;
      emacs = enabled // {
        package = pkgs.emacs29;
      };
      direnv = enabled;
    };
  };
}
