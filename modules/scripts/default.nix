{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.scripts;
  moveToScriptDir = mapAttrs' (k: v: nameValuePair ("Scripts/" + k) v);
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
    home.file = moveToScriptDir (cfg.script // defaultScripts);
  };
}
