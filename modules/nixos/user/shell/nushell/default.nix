{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.elementary.user.shell.nushell;
in
{
  options.elementary.user.shell.nushell = {
    enable = lib.mkEnableOption "Nushell";
  };

  config = lib.mkIf cfg.enable {
    users.users.${config.elementary.user.name}.shell = pkgs.nushell;

    elementary.home.programs = {
      nushell = {
        enable = true;
        settings = {
          show_banner = false;
        };
        shellAliases = {
          "dl" = "rm --trash";
        };
        extraConfig = ''
          def rec [] {
            ls **/* | where type == file
          }
          def reca [] {
            ls -a **/* | where type == file
          }
        '';
      };
      starship = {
        enable = true;
        enableNushellIntegration = true;
        settings.username.show_always = true;
      };
      zoxide = {
        enable = true;
        enableNushellIntegration = true;
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
    };
  };
}
