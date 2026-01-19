{
  inputs,
  lib,
  self,
  config,
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

  options.roles.work = {
    enable = mkEnableOption "the work role";
    forUsers = mkOption {
      type = nonEmptyListOf str;
      default = [ config.constants.default.user.name ];
    };
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;

    home-manager = {
      sharedModules = [ self.homeModules."roles.work" ];
      users = genAttrs cfg.forUsers (_: {
        roles.work.enable = true;
      });
    };

    networking.firewall.allowedTCPPorts = [
      1499 # For MSSQL containers -> Windows
    ];
  };
}
