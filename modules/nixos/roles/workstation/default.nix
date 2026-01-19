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
  inherit (lib.types) listOf str;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    self.nixosModules."constants"
  ];

  options.roles.workstation = {
    enable = mkEnableOption "the workstation role";
    forUsers = mkOption {
      type = listOf str;
      default = [ config.constants.default.user.name ];
    };
  };

  config = mkIf cfg.enable {
    security.sudo.wheelNeedsPassword = false;

    home-manager = {
      sharedModules = [
        self.homeModules."cliTools"
        self.homeModules."programs.git"
        self.homeModules."programs.gpg"
        self.homeModules."programs.nh"
        self.homeModules."programs.zsh"
      ];

      users = genAttrs cfg.forUsers (_: {
        cliTools.enable = true;

        programs = {
          gpg = {
            enable = true;
            elementary.config.enable = true;
          };

          git = {
            enable = true;
            elementary.config.enable = true;
          };

          zsh = {
            enable = true;
            elementary.config.enable = true;
          };

          nh = {
            enable = true;
            elementary.config.enable = true;
          };
        };
      });
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
        direnv.enable = true;
      };
    };
  };
}
