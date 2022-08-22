{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.emacs;
  doomLogPath = "~/.doom.log";
  emacsRunCmd = "doom run > ${doomLogPath}";
in {
  options.modules.emacs = {
    enable = mkEnableOption "Whether to enable Doom Emacs";
  };

  config = mkIf cfg.enable {
    programs = {
      doom-emacs = {
        enable = true;
        doomPrivateDir = ./doom.d;
      };

      fish.shellAliases = {
        "e" = emacsRunCmd;
        "emacs" = emacsRunCmd;
      };
    };
  };
}
