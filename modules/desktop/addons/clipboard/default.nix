{ config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.clipboard;
in
{
  options.plusultra.desktop.addons.clipboard = {
    enable = mkEnableOption "Wayland clipboard utilities and configuration";
  };

  config = mkIf cfg.enable {
    plusultra.home.packages = with pkgs; [
      wl-clipboard
    ];

    plusultra.home.shellAliases = {
      "cb" = "wl-copy";
      "cb1" = "wl-copy --paste-once";
      "cbo" = "wl-paste";
    };
  };
}
