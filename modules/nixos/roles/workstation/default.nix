{
  inputs,
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.roles.workstation;
  inherit (lib)
    genAttrs
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit (lib.types) nonEmptyListOf str;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    self.nixosModules."constants"
  ];

  options.roles.workstation = {
    enable = mkEnableOption "the workstation role";
    forUsers = mkOption {
      type = nonEmptyListOf str;
      default = [ config.constants.default.user.name ];
    };
  };

  config = mkIf cfg.enable {
    security.sudo.wheelNeedsPassword = false;

    home-manager = {
      sharedModules = [
        self.homeModules."cliTools"
        self.homeModules."programs.direnv"
        self.homeModules."programs.git"
        self.homeModules."programs.gpg"
        self.homeModules."programs.nh"
        self.homeModules."programs.zsh"
      ];

      users = genAttrs cfg.forUsers (
        _:
        { config, ... }:
        {
          xdg.userDirs = {
            enable = true;
            createDirectories = true;
          };

          cliTools.enable = true;

          # This is cringe beyond belief
          # See: https://pkg.go.dev/cmd/go#hdr-GOPATH_environment_variable
          home.sessionVariables.GOPATH = lib.path.append (/. + config.xdg.dataHome) "go";

          programs = {
            direnv = {
              enable = true;
              elementary.config.enable = true;
            };
            git = {
              enable = true;
              elementary.config.enable = true;
            };
            gpg = {
              enable = true;
              elementary.config.enable = true;
            };
            nh = {
              enable = true;
              elementary.config.enable = true;
            };
            zsh = {
              enable = true;
              elementary.config.enable = true;
            };
          };
        }
      );
    };

    virtualisation.docker.enable = true;

    elementary = {
      nix.enable = true;
      home.enable = true;
      user = {
        enable = true;
        inherit (config.constants.default.user) name;
      };
      secrets.enable = true;
      programs = {
        ssh.enable = true;
        emacs.enable = true;
      };
    };
  };
}
