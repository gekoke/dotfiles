{
  inputs,
  lib,
  pkgs,
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
  inherit (lib.types) listOf str;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    self.nixosModules."constants"
  ];

  options.roles.work = {
    enable = mkEnableOption "the work role";
    forUsers = mkOption {
      type = listOf str;
      default = [ config.constants.default.user.name ];
    };
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;

    home-manager.users = genAttrs cfg.forUsers (_: {
      home = {
        file."Work/.hmkeep".text = "";

        packages = [
          # keep-sorted start block=yes
          pkgs.azure-cli
          pkgs.bun
          pkgs.powershell
          # keep-sorted end
        ];
      };
    });

    networking.firewall.allowedTCPPorts = [
      1499 # For MSSQL containers -> Windows
    ];
  };
}
