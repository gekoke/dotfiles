{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.services.mediakeys;
  notificationId = 3290313;
  volumeStep = 0.05;
  mediavolumeup = pkgs.writeShellScriptBin "mediavolumeup" ''
    ${pkgs.playerctl}/bin/playerctl volume ${toString volumeStep}+
  '';
  mediavolumedown = pkgs.writeShellScriptBin "mediavolumedown" ''
    ${pkgs.playerctl}/bin/playerctl volume ${toString volumeStep}-
  '';
in
{
  options.modules.services.mediakeys = {
    enable = mkEnableOption "media keys";
  };

  config = mkIf cfg.enable {
    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + shift + bracketleft" = "${pkgs.playerctl}/bin/playerctl previous";
        "super + shift + bracketright" = "${pkgs.playerctl}/bin/playerctl next";
        "super + shift + plus" = "${pkgs.playerctl}/bin/playerctl play-pause";
        "super + shift + o" = "${mediavolumedown}/bin/mediavolumedown";
        "super + shift + p" = "${mediavolumeup}/bin/mediavolumeup";
      };
    };
  };
}
