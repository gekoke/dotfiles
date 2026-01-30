{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.roles.work;
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) nullOr nonEmptyStr;
in
{
  options.roles.work = {
    enable = mkEnableOption "work role";
    email = mkOption {
      type = nullOr nonEmptyStr;
      default = null;
    };
  };

  config =
    let
      workDir = "Work";
      inherit (lib) mkIf;
    in
    mkIf cfg.enable {
      home = {
        file."${workDir}/.hmkeep".text = "";

        packages = [
          # keep-sorted start block=yes
          pkgs.azure-cli
          pkgs.bun
          pkgs.opencode
          pkgs.powershell
          # keep-sorted end
        ];
      };

      programs.git.includes = [
        (mkIf (cfg.email != null) {
          condition = "gitdir:~/${workDir}/";
          contents.user.email = cfg.email;
        })
      ];
    };
}
