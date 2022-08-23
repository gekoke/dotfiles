{
  lib,
  config,
  ...
}:
with lib; let
  scriptDir = ".user-scripts";
  cfg = config.modules.scripts;

  moveToScriptDir = mapAttrs' (n: v: nameValuePair "${scriptDir}/${n}" v);

  defaultScripts = {
    "" = {
      source = ./Scripts;
      recursive = true;
      executable = true;
    };
  };
in {
  options.modules.scripts = {
    enable = mkEnableOption "User scripts";

    script = mkOption {
      description = "Attribute set of scripts to add to the user's scripts directory";
      default = {};
      type = types.attrs;
    };
  };

  config = mkIf cfg.enable {
    home = {
      file = moveToScriptDir (cfg.script // defaultScripts);
      sessionPath = [ "$HOME/${scriptDir}" ];
    };
  };
}
