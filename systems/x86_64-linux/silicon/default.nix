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

  elementary = {
    virtualisation.docker.enable = true;
    nix = enabled;
    user = enabled // {
      accounts = enabled;
    };
    suites = {
      cli-utils = enabled;
    };
    security = {
      gpg = enabled;
      sudo = enabled;
    };
    programs = {
      git = enabled // {
        signingKey = "FB5F09CB29F94BC5";
        userEmail = "gregor.grigorjan@gamesglobal.com";
      };
      ssh = enabled;
      emacs = enabled // {
        package = pkgs.emacs29;
      };
      direnv = enabled;
      spotify = enabled;
    };
  };
}
