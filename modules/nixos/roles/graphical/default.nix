{
  inputs,
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.roles.graphical;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    genAttrs
    ;
  inherit (lib.types) listOf str;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    self.nixosModules.constants
  ];

  options.roles.graphical = {
    enable = mkEnableOption "the graphical role";
    forUsers = mkOption {
      type = listOf str;
      default = [ config.constants.default.user.name ];
    };
  };

  config = mkIf cfg.enable {
    home-manager.users = genAttrs cfg.forUsers (_: {
      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
      home.packages = [
        # pinentry-gnome3
        pkgs.gcr

        pkgs.discord
        pkgs.mpv
        pkgs.qbittorrent
        pkgs.spotify
      ];
    });

    # FIXME: make it work with `forUsers`
    elementary = {
      suites.desktop.enable = true;
      programs.firefox.enable = true;
      system.boot.enable = true;
    };
  };
}
