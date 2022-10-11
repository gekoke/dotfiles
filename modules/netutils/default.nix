{ pkgs
, lib
, config
, ...
}:
with lib; let
  popen = pkgs.writeShellScriptBin "popen" (builtins.readFile ./popen.sh);
  pclose = pkgs.writeShellScriptBin "pclose" (builtins.readFile ./pclose.sh);

  cfg = config.modules.netutils;
in {
  options.modules.netutils = {
    enable = mkEnableOption "net utilities";
  };

  config = mkIf cfg.enable {
    home.packages = [
      popen
      pclose
    ];
  };
}
