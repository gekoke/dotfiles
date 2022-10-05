{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.mediakeys;
  notificationId = 3290313;
  volumeStep = 0.05;
  mediavolumeup = pkgs.writeShellScriptBin "mediavolumeup" ''
    playerctl volume ${toString volumeStep}+ && dunstify "Media volume increased -> $(playerctl volume)" -r ${toString notificationId}
  '';
  mediavolumedown = pkgs.writeShellScriptBin "mediavolumeup" ''
    playerctl volume ${toString volumeStep}- && dunstify "Media volume decreased -> $(playerctl volume)" -r ${toString notificationId}
  '';
in {
  imports = [
    ../dunst
  ];

  options.modules.mediakeys = {
    enable = mkEnableOption "Media keys";
  };

  config = mkIf cfg.enable {
    modules.dunst.enable = true;
    home.packages = with pkgs; [
      playerctl
      mediavolumeup
      mediavolumedown
    ];
    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + shift + bracketleft" = "mediavolumedown";
        "super + shift + bracketright" = "mediavolumeup";
      };
    };
  };
}
