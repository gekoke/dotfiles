{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.noshell;
in
{
  options.programs.noshell =
    let
      inherit (lib) mkEnableOption mkOption;
      inherit (lib.types) package;
    in
    {
      enable = mkEnableOption "noshell";
      shellPackage = mkOption { type = package; };
    };

  config = lib.mkIf cfg.enable {
    # Set using https://github.com/viperML/noshell
    xdg.configFile =
      let
        filename = lib.getName cfg.shellPackage;
      in
      {
        "${filename}".source = lib.getExe cfg.shellPackage;
        "shell" = {
          executable = true;
          text = ''
            exec ${config.xdg.configHome}/${filename} "$@"
          '';
        };
      };
  };
}
