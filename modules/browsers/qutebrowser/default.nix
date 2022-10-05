{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.browsers.qutebrowser;
  pythonDependencies = python-packages: with python-packages; [ adblock ];
in
{
  options.modules.browsers.qutebrowser = {
    enable = mkEnableOption "Qutebrowser module";
  };

  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      extraConfig = builtins.readFile ./config.py;
    };
    home.packages = with pkgs; [
      (python38.withPackages pythonDependencies)
    ];
  };
}
