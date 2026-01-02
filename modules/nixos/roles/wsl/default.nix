{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.roles.wsl;
  inherit (lib)
    elem
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
    inputs.nixos-wsl.nixosModules.default
    self.nixosModules."constants"
  ];

  options.roles.wsl = {
    enable = mkEnableOption "the WSL role";
    defaultUser = mkOption {
      type = str;
      default = config.constants.default.user.name;
    };
    forUsers = mkOption {
      type = listOf str;
      default = [ cfg.defaultUser ];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = elem cfg.defaultUser cfg.forUsers;
        message = "config.roles.wsl.defaultUser (${toString cfg.defaultUser}) must be an element of config.roles.wsl.forUsers (${toString cfg.forUsers})";
      }
    ];

    wsl = {
      enable = true;
      wslConf.user.default = cfg.defaultUser;
      inherit (cfg) defaultUser;
    };

    home-manager.users = genAttrs cfg.forUsers (_: {
      home.shellAliases = {
        "cb" = "clip.exe";
        "cbo" = "powershell.exe Get-ClipBoard";
      };
      services.gpg-agent.pinentry.package = pkgs.pinentry-gtk2;
    });
  };
}
