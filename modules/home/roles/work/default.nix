{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.roles.work;
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) nullOr nonEmptyStr;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [ inputs.pi.homeModules.default ];

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

        sessionVariables.PI_OFFLINE = 1;

        packages = [
          # keep-sorted start block=yes
          pkgs.azure-cli
          pkgs.bun
          pkgs.opencode
          pkgs.powershell
          # keep-sorted end
        ];
      };

      programs.pi.coding-agent = {
        enable = true;
        extensions = [
          "${inputs.self.packages.${system}.pi-anthropic-auth}/pi-anthropic-auth/index.js"
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
