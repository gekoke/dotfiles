{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.browsers.qutebrowser;
  pythonDependencies = python-packages: with python-packages; [ adblock ];
  paletteAsJson = builtins.toJSON config.prefs.style.palette;
in
{
  options.modules.browsers.qutebrowser = {
    enable = mkEnableOption "Qutebrowser";
  };

  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      extraConfig = ''
        ${builtins.readFile ./config.py}
        import json
        theme = ${paletteAsJson} # Also a valid Python dictionary
        ${builtins.readFile ./theme.py}
      '';
    };
    home.packages = with pkgs; [
      (python39.withPackages pythonDependencies)
    ];
  };
}
