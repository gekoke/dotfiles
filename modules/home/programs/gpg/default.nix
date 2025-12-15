{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.gpg.elementary.config;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.programs.gpg.elementary.config = {
    enable = mkEnableOption "Elementary GPG configuration";
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
