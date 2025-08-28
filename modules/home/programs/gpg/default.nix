{
  config,
  lib,
  ...
}:
let
  cfg = config.elementary.programs.gpg;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.elementary.programs.gpg = {
    enable = mkEnableOption "gpg-agent configuration";
  };

  config = mkIf cfg.enable {
    programs.gpg.enable = true;
    services.gpg-agent =
      let
        ttlInSeconds = 8 * 60 * 60;
      in
      {
        enable = true;
        defaultCacheTtl = ttlInSeconds;
        maxCacheTtl = ttlInSeconds;
      };
  };
}
