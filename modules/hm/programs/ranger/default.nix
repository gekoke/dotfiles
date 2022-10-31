{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.programs.ranger;
in {
  options.modules.programs.ranger = {
    enable = mkEnableOption "ranger file manager";
  };

  config = mkIf cfg.enable {
    xdg.configFile."ranger/rifle.conf".source = ./config/rifle.conf;
    xdg.configFile."ranger/rc.conf".source = ./config/rc.conf;
    xdg.configFile."ranger/scope.sh".source = ./config/scope.sh;

    home = {
      packages = with pkgs; [
        ranger
        ueberzug
      ];
      shellAliases.ra = "ranger";
    };
  };
}
