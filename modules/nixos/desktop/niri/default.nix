{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.elementary.desktop.niri;
in
{
  imports = [
    inputs.niri-flake.nixosModules.niri
  ];

  options.elementary.desktop.niri = {
    enable = lib.mkEnableOption "Niri desktop environment";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };
    environment.variables = {
      NIXOS_OZONE_WL = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
    home-manager = {
      sharedModules = [
        inputs.dank-material-shell.homeModules.dankMaterialShell.default
        inputs.dank-material-shell.homeModules.dankMaterialShell.niri
      ];
      users."${config.elementary.user.name}" = {
        programs = {
          niri.settings = import ./settings.nix;
          dankMaterialShell = {
            enable = true;
            systemd.enable = true;
          };
        };
      };
    };
  };
}
