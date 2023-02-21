{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.services.email;
in
{
  options.modules.services.email = {
    enable = mkEnableOption "email";
  };

  config = mkIf cfg.enable {
    accounts.email = {
      accounts = {
        school = {
          realName = "Gregor Grigorjan";
          address = "grgrig@ttu.ee";
        };
        personal = {
          primary = true;
          realName = "gekoke";
          address = "gekoke@lazycantina.xyz";
        };
      };
    };
  };
}
